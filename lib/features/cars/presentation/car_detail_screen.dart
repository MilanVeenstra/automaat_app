import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../rentals/presentation/providers/rentals_provider.dart';
import '../domain/entities/car.dart';
import 'providers/cars_provider.dart';

/// Car detail screen showing detailed car information
class CarDetailScreen extends ConsumerStatefulWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final carsState = ref.watch(carsNotifierProvider);
    final isFavorite = carsState.favoriteIds.contains(widget.car.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.car.brand} ${widget.car.model}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            // Car image
            _buildCarImage(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand and Model
                  Text(
                    '${widget.car.brand} ${widget.car.model}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Year and License Plate
                  Text(
                    '${widget.car.modelYear} • ${widget.car.licensePlate}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
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
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Specifications
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

                  // Location
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Lat: ${widget.car.latitude!.toStringAsFixed(4)}, '
                              'Lon: ${widget.car.longitude!.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Rent button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _showRentalDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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
                ],
              ),
            ),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
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
      // Get current location
      Position? position;
      try {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          final requested = await Geolocator.requestPermission();
          if (requested == LocationPermission.denied ||
              requested == LocationPermission.deniedForever) {
            throw Exception('Location permission denied');
          }
        }
        position = await Geolocator.getCurrentPosition();
      } catch (e) {
        // If location fails, use car's location or Rotterdam as fallback
        position = null;
      }

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
                longitude: position?.longitude ?? widget.car.longitude ?? 4.4777,
                latitude: position?.latitude ?? widget.car.latitude ?? 51.9244,
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
}
