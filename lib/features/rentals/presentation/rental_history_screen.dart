import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/location_helper.dart';
import '../../inspections/presentation/create_damage_report_screen.dart';
import '../domain/entities/rental.dart';
import 'providers/rentals_provider.dart';
import 'widgets/rental_card.dart';

/// Verhuur geschiedenis scherm met eerdere en actieve verhuur
class RentalHistoryScreen extends ConsumerStatefulWidget {
  const RentalHistoryScreen({super.key});

  @override
  ConsumerState<RentalHistoryScreen> createState() =>
      _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends ConsumerState<RentalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(rentalsNotifierProvider.notifier).loadRentals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentalsState = ref.watch(rentalsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rentals'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildContent(rentalsState),
    );
  }

  Widget _buildContent(RentalsState state) {
    if (state.status == RentalsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == RentalsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.error ?? 'An error occurred',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(rentalsNotifierProvider.notifier).loadRentals();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.rentals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.car_rental, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No rentals yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Start renting a car to see it here',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final activeRentals = ref.read(rentalsNotifierProvider.notifier).activeRentals;
    final pastRentals = ref.read(rentalsNotifierProvider.notifier).pastRentals;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(rentalsNotifierProvider.notifier).loadRentals(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeRentals.isNotEmpty) ...[
            const Text(
              'Active Rentals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...activeRentals.map((rental) => RentalCard(
                  rental: rental,
                  onEndRental: () => _showEndRentalDialog(rental),
                  onReportDamage: () => _navigateToReportDamage(rental),
                )),
            const SizedBox(height: 24),
          ],
          if (pastRentals.isNotEmpty) ...[
            const Text(
              'Past Rentals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...pastRentals.map((rental) => RentalCard(rental: rental)),
          ],
        ],
      ),
    );
  }

  void _navigateToReportDamage(Rental rental) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateDamageReportScreen(rental: rental),
      ),
    );
  }

  void _showEndRentalDialog(Rental rental) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Rental'),
        content: Text(
          'Are you sure you want to end the rental for ${rental.car.brand} ${rental.car.model}?\n\n'
          'Your current location will be recorded as the return location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _endRental(rental);
            },
            child: const Text('End Rental'),
          ),
        ],
      ),
    );
  }

  Future<void> _endRental(Rental rental) async {
    // Haal huidige locatie op of gebruik fallback
    final location = await LocationHelper.getCurrentLocationOrFallback();

    final success = await ref.read(rentalsNotifierProvider.notifier).endRental(
          rentalId: rental.id,
          carId: rental.car.id,
          longitude: location.longitude,
          latitude: location.latitude,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            location.isFallback
                ? 'Rental ended successfully. Used fallback location.'
                : 'Rental ended successfully. Car location updated.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to end rental')),
      );
    }
  }
}
