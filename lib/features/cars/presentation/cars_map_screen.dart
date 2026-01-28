import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../domain/entities/car.dart';
import 'car_detail_screen.dart';
import 'providers/cars_provider.dart';

/// Kaart met alle auto's
class CarsMapScreen extends ConsumerStatefulWidget {
  const CarsMapScreen({super.key});

  @override
  ConsumerState<CarsMapScreen> createState() => _CarsMapScreenState();
}

class _CarsMapScreenState extends ConsumerState<CarsMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  // Standaard locatie (Rotterdam)
  static const LatLng _defaultLocation = LatLng(51.9244, 4.4777);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final carsState = ref.watch(carsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars on Map'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Stack(
        children: [
          _buildBody(carsState),
          // Mijn locatie knop
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _isLoadingLocation ? null : _centerOnMyLocation,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CarsState carsState) {
    if (carsState.status == CarsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (carsState.status == CarsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${carsState.error}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(carsNotifierProvider.notifier).loadCars(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Filter auto's die locatie data hebben
    final carsWithLocation = carsState.cars
        .where((car) => car.latitude != null && car.longitude != null)
        .toList();

    if (carsWithLocation.isEmpty) {
      return const Center(
        child: Text('No cars with location data available'),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _defaultLocation,
        initialZoom: 12.0,
        minZoom: 3.0,
        maxZoom: 18.0,
        onMapReady: () => _fitMarkersInView(carsWithLocation),
      ),
      children: [
        // Kaart laag
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.automaat.automaat_app',
          maxZoom: 19,
        ),
        // Auto markers
        MarkerLayer(
          markers: [
            ..._buildMarkers(carsWithLocation),
            if (_currentLocation != null) _buildUserLocationMarker(),
          ],
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(List<Car> cars) {
    return cars.map((car) {
      return Marker(
        point: LatLng(car.latitude!, car.longitude!),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _onMarkerTap(car),
          child: Column(
            children: [
              // Auto marker icoon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _onMarkerTap(Car car) {
    // Toon auto info
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${car.brand} ${car.model}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${car.modelYear} • ${car.licensePlate}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '€${car.price.toStringAsFixed(2)}/day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CarDetailScreen(car: car),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fitMarkersInView(List<Car> cars) {
    if (cars.isEmpty) return;

    double minLat = cars.first.latitude!;
    double maxLat = cars.first.latitude!;
    double minLng = cars.first.longitude!;
    double maxLng = cars.first.longitude!;

    for (var car in cars) {
      if (car.latitude! < minLat) minLat = car.latitude!;
      if (car.latitude! > maxLat) maxLat = car.latitude!;
      if (car.longitude! < minLng) minLng = car.longitude!;
      if (car.longitude! > maxLng) maxLng = car.longitude!;
    }

    final bounds = LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  void _centerOnMyLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0);
    } else {
      _getCurrentLocation().then((_) {
        if (_currentLocation != null) {
          _mapController.move(_currentLocation!, 15.0);
        }
      });
    }
  }

  Marker _buildUserLocationMarker() {
    return Marker(
      point: _currentLocation!,
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Buitenste cirkel
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
          // Binnenste cirkel
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
