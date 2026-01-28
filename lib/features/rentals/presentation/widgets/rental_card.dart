import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/rental.dart';

/// Card widget voor het weergeven van verhuur informatie
class RentalCard extends StatelessWidget {
  final Rental rental;
  final VoidCallback? onStartRental;
  final VoidCallback? onEndRental;
  final VoidCallback? onReportDamage;

  const RentalCard({
    super.key,
    required this.rental,
    this.onStartRental,
    this.onEndRental,
    this.onReportDamage,
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
                // Auto afbeelding
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildCarImage(),
                ),
                const SizedBox(width: 16),

                // Auto en verhuur details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Merk en model
                      Text(
                        '${rental.car.brand} ${rental.car.model}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Verhuur code
                      Text(
                        'Rental #${rental.code}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Status badge
                      _buildStateBadge(),
                      const SizedBox(height: 8),

                      // Datum bereik
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

                      // Prijs
                      const SizedBox(height: 8),
                      Text(
                        '€${rental.car.price.toStringAsFixed(2)} / day',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Actie knoppen voor gereserveerde/actieve verhuur
            if ((rental.isReserved || rental.isActive) &&
                (onStartRental != null || onEndRental != null || onReportDamage != null)) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Gereserveerd: toon Start Rit knop
              if (rental.isReserved && onStartRental != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onStartRental,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Start Ride'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

              // Actief: toon Schade Melden en Beëindig Verhuur knoppen
              if (rental.isActive)
                Row(
                  children: [
                    if (onReportDamage != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReportDamage,
                          icon: const Icon(Icons.report_problem, size: 18),
                          label: const Text('Report Damage'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (onReportDamage != null && onEndRental != null)
                      const SizedBox(width: 12),
                    if (onEndRental != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onEndRental,
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: const Text('End Rental'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                  ],
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
    Color backgroundColor;
    Color textColor;

    switch (rental.state) {
      case RentalState.active:
        backgroundColor = const Color(0xFF000000); // Zwart voor actief
        textColor = Colors.white;
        break;
      case RentalState.reserved:
        backgroundColor = const Color(0xFFF5F5F5); // Lichtgrijs voor gereserveerd
        textColor = const Color(0xFF000000);
        break;
      case RentalState.pickup:
        backgroundColor = const Color(0xFF424242); // Donkergrijs voor ophalen
        textColor = Colors.white;
        break;
      case RentalState.returned:
        backgroundColor = const Color(0xFFEEEEEE); // Zeer lichtgrijs voor ingeleverd
        textColor = const Color(0xFF757575);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        rental.state.displayName.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
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
