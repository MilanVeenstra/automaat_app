import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/car.dart';
import '../providers/cars_provider.dart';

/// Filter dialoog voor het selecteren van brandstof en carrosserie type filters
class FilterDialog extends ConsumerWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsState = ref.watch(carsNotifierProvider);

    return AlertDialog(
      title: const Text('Filter Cars'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fuel Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: CarFuel.values.map((fuel) {
                final isSelected =
                    carsState.fuelFilters?.contains(fuel) ?? false;
                return FilterChip(
                  label: Text(fuel.displayName),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(carsNotifierProvider.notifier)
                        .toggleFuelFilter(fuel);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Body Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: CarBody.values.map((body) {
                final isSelected =
                    carsState.bodyFilters?.contains(body) ?? false;
                return FilterChip(
                  label: Text(body.displayName),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(carsNotifierProvider.notifier)
                        .toggleBodyFilter(body);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(carsNotifierProvider.notifier).clearFilters();
            Navigator.of(context).pop();
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
