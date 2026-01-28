import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/cars_provider.dart';
import 'widgets/car_card.dart';

/// Auto lijst scherm met beschikbare huurauto's
class CarsListScreen extends ConsumerStatefulWidget {
  const CarsListScreen({super.key});

  @override
  ConsumerState<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends ConsumerState<CarsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Laad auto's bij scherm initialisatie
    Future.microtask(() {
      ref.read(carsNotifierProvider.notifier).loadCars();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carsState = ref.watch(carsNotifierProvider);

    return Column(
        children: [
          // Zoekbalk
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by brand or model...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(carsNotifierProvider.notifier)
                              .searchCars('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                ref.read(carsNotifierProvider.notifier).searchCars(value);
                setState(() {});
              },
            ),
          ),

          // Actieve filter chips
          if (carsState.fuelFilters != null ||
              carsState.bodyFilters != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                children: [
                  if (carsState.fuelFilters != null)
                    ...carsState.fuelFilters!.map((fuel) => Chip(
                          label: Text(fuel.displayName),
                          onDeleted: () {
                            ref
                                .read(carsNotifierProvider.notifier)
                                .toggleFuelFilter(fuel);
                          },
                        )),
                  if (carsState.bodyFilters != null)
                    ...carsState.bodyFilters!.map((body) => Chip(
                          label: Text(body.displayName),
                          onDeleted: () {
                            ref
                                .read(carsNotifierProvider.notifier)
                                .toggleBodyFilter(body);
                          },
                        )),
                  TextButton.icon(
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('Clear all'),
                    onPressed: () {
                      ref.read(carsNotifierProvider.notifier).clearFilters();
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),

          // Auto lijst
          Expanded(
            child: _buildContent(carsState),
          ),
        ],
      );
  }

  Widget _buildContent(CarsState state) {
    if (state.status == CarsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CarsStatus.error) {
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
                ref.read(carsNotifierProvider.notifier).loadCars();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.filteredCars.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car_outlined,
                size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty ||
                      state.fuelFilters != null ||
                      state.bodyFilters != null
                  ? 'No cars match your filters'
                  : 'No cars available',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(carsNotifierProvider.notifier).loadCars(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.filteredCars.length,
        itemBuilder: (context, index) {
          final car = state.filteredCars[index];
          return CarCard(car: car);
        },
      ),
    );
  }
}
