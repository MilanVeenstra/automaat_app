import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_constants.dart';
import '../../../core/utils/location_helper.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../rentals/presentation/providers/rentals_provider.dart';
import '../domain/entities/car.dart';
import 'providers/cars_provider.dart';

/// Auto detail scherm
class CarDetailScreen extends ConsumerStatefulWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  bool _isLoading = false;
  LatLng? _currentLocation;
  List<LatLng> _routePoints = [];
  double? _routeDistance; // in kilometers
  double? _routeDuration; // in minutes
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Haal route op van OSRM (OpenStreetMap routing service)
  Future<void> _fetchRoute() async {
    if (_currentLocation == null ||
        widget.car.latitude == null ||
        widget.car.longitude == null) {
      return;
    }

    setState(() => _isLoadingRoute = true);

    try {
      final startLon = _currentLocation!.longitude;
      final startLat = _currentLocation!.latitude;
      final endLon = widget.car.longitude!;
      final endLat = widget.car.latitude!;

      // OSRM demo server - gratis routing
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '$startLon,$startLat;$endLon,$endLat'
        '?overview=full&geometries=geojson',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['routes'][0];
        final geometry = route['geometry']['coordinates'] as List;

        setState(() {
          _routePoints = geometry
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();
          _routeDistance = route['distance'] / 1000; // meters naar km
          _routeDuration = route['duration'] / 60; // seconden naar minuten
          _isLoadingRoute = false;
        });
      } else {
        setState(() => _isLoadingRoute = false);
      }
    } catch (e) {
      setState(() => _isLoadingRoute = false);
      // Route is optioneel - fout wordt genegeerd
    }
  }

  @override
  Widget build(BuildContext context) {
    final carsState = ref.watch(carsNotifierProvider);
    final isFavorite = carsState.favoriteIds.contains(widget.car.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.car.brand} ${widget.car.model}'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              ref
                  .read(carsNotifierProvider.notifier)
                  .toggleFavorite(widget.car.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Auto afbeelding
            _buildCarImage(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Merk en model
                  Text(
                    '${widget.car.brand} ${widget.car.model}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bouwjaar en kenteken
                  Text(
                    '${widget.car.modelYear} • ${widget.car.licensePlate}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Prijs
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price per day',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '€${widget.car.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Specificaties
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSpecRow(
                    Icons.local_gas_station,
                    'Fuel Type',
                    widget.car.fuel.displayName,
                  ),
                  const Divider(),
                  _buildSpecRow(
                    Icons.directions_car,
                    'Body Type',
                    widget.car.body.displayName,
                  ),
                  const Divider(),
                  _buildSpecRow(
                    Icons.person,
                    'Seats',
                    '${widget.car.nrOfSeats} seats',
                  ),
                  const Divider(),
                  _buildSpecRow(
                    Icons.speed,
                    'Engine Size',
                    '${widget.car.engineSize.toStringAsFixed(1)}L',
                  ),

                  const SizedBox(height: 24),

                  // Locatie kaart met verhuur knop
                  if (widget.car.latitude != null &&
                      widget.car.longitude != null) ...[
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),

            // Kaart met verhuur knop
            if (widget.car.latitude != null && widget.car.longitude != null)
              Stack(
                children: [
                  // OpenStreetMap kaart
                  SizedBox(
                    height: 300,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          widget.car.latitude!,
                          widget.car.longitude!,
                        ),
                        initialZoom: 14.0,
                        minZoom: 3.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.automaat.automaat_app',
                          maxZoom: 19,
                        ),
                        // Route lijn
                        if (_routePoints.isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _routePoints,
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 4.0,
                              ),
                            ],
                          ),
                        MarkerLayer(
                          markers: [
                            // Auto marker
                            Marker(
                              point: LatLng(
                                widget.car.latitude!,
                                widget.car.longitude!,
                              ),
                              width: 40,
                              height: 40,
                              child: Container(
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
                            ),
                            // Gebruiker locatie marker
                            if (_currentLocation != null)
                              Marker(
                                point: _currentLocation!,
                                width: 50,
                                height: 50,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
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
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Route informatie banner
                  if (_routeDistance != null && _routeDuration != null)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.straighten, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${_routeDistance!.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${_routeDuration!.toStringAsFixed(0)} min',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Zwevende verhuur knop
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _showRentalDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Rent This Car',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),

            // Ruimte onderaan
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    if (widget.car.picture != null && widget.car.picture!.isNotEmpty) {
      try {
        final bytes = base64Decode(widget.car.picture!);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } catch (e) {
        return _buildPlaceholder();
      }
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[300],
      child: const Icon(
        Icons.directions_car,
        size: 100,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey[700]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showRentalDialog() {
    final now = DateTime.now();
    DateTime fromDate = now;
    DateTime toDate = now.add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Start Rental'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rent ${widget.car.brand} ${widget.car.model}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('From'),
                subtitle: Text(_formatDate(fromDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: fromDate,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      fromDate = picked;
                      if (toDate.isBefore(fromDate)) {
                        toDate = fromDate.add(const Duration(days: 1));
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('To'),
                subtitle: Text(_formatDate(toDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: toDate,
                    firstDate: fromDate.add(const Duration(days: 1)),
                    lastDate: now.add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      toDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Total: €${_calculateTotal(fromDate, toDate)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startRental(fromDate, toDate);
              },
              child: const Text('Start Rental'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateTotal(DateTime from, DateTime to) {
    final days = to.difference(from).inDays;
    return (widget.car.price * days).toStringAsFixed(2);
  }

  Future<void> _startRental(DateTime fromDate, DateTime toDate) async {
    setState(() => _isLoading = true);

    try {
      // Haal huidige locatie op of gebruik fallback
      final location = await LocationHelper.getCurrentLocationOrFallback();

      final authState = ref.read(authNotifierProvider);
      if (authState.user == null) {
        throw Exception('User not logged in');
      }

      final success =
          await ref.read(rentalsNotifierProvider.notifier).createRental(
                carId: widget.car.id,
                customerId: authState.user!.id,
                fromDate: fromDate,
                toDate: toDate,
                longitude: location.longitude,
                latitude: location.latitude,
                car: widget.car,
              );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rental started successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to create rental');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await LocationHelper.getCurrentLocationOrFallback();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(location.latitude, location.longitude);
        });
        // Haal automatisch route op
        await _fetchRoute();
      }
    } catch (e) {
      // Gebruikerslocatie is optioneel - gebruik fallback indien nodig
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(
            AppConstants.fallbackLatitude,
            AppConstants.fallbackLongitude,
          );
        });
      }
    }
  }
}
