import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/car.dart';
import 'providers/cars_provider.dart';
import 'widgets/car_card.dart';

/// Favorieten scherm
class FavoritesScreen extends ConsumerWidget {
  final bool showAppBar;

  const FavoritesScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsState = ref.watch(carsNotifierProvider);

    // Filter alleen favorieten
    final favoriteCars = carsState.cars
        .where((car) => carsState.favoriteIds.contains(car.id))
        .toList();

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Favorites'),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            )
          : null,
      body: Column(
        children: [
          if (!showAppBar)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Row(
                children: [
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _buildBody(context, carsState.status, favoriteCars)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CarsStatus status, List<Car> favoriteCars) {
    if (status == CarsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status == CarsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Failed to load cars'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (favoriteCars.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any car to add it to your favorites',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteCars.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CarCard(car: favoriteCars[index]),
        );
      },
    );
  }
}
