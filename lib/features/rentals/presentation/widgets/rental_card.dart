import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/rental.dart';

/// Card widget displaying rental information
class RentalCard extends StatelessWidget {
  final Rental rental;
  final VoidCallback? onEndRental;

  const RentalCard({
    super.key,
    required this.rental,
    this.onEndRental,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildCarImage(),
                ),
                const SizedBox(width: 16),

                // Car and rental details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car brand and model
                      Text(
                        '${rental.car.brand} ${rental.car.model}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Rental code
                      Text(
                        'Rental #${rental.code}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // State badge
                      _buildStateBadge(),
                      const SizedBox(height: 8),

                      // Date range
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _formatDateRange(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Price
                      const SizedBox(height: 8),
                      Text(
                        '€${rental.car.price.toStringAsFixed(2)} / day',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // End rental button for active rentals
            if (rental.isActive && onEndRental != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onEndRental,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('End Rental'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    if (rental.car.picture != null && rental.car.picture!.isNotEmpty) {
      try {
        final bytes = base64Decode(rental.car.picture!);
        return Image.memory(
          bytes,
          width: 80,
          height: 80,
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
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: const Icon(
        Icons.directions_car,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildStateBadge() {
    Color color;
    switch (rental.state) {
      case RentalState.active:
        color = Colors.green;
        break;
      case RentalState.reserved:
        color = Colors.orange;
        break;
      case RentalState.pickup:
        color = Colors.blue;
        break;
      case RentalState.returned:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        rental.state.displayName,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateRange() {
    final formatter = DateFormat('MMM d, yyyy');
    final from = formatter.format(rental.fromDate);
    final to = formatter.format(rental.toDate);
    return '$from - $to';
  }
}
