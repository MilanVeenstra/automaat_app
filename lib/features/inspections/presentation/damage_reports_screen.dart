import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'providers/inspections_provider.dart';

/// Scherm voor het weergeven van alle schade rapporten
class DamageReportsScreen extends ConsumerStatefulWidget {
  const DamageReportsScreen({super.key});

  @override
  ConsumerState<DamageReportsScreen> createState() =>
      _DamageReportsScreenState();
}

class _DamageReportsScreenState extends ConsumerState<DamageReportsScreen> {
  @override
  void initState() {
    super.initState();
    // Laad inspecties wanneer scherm opent
    Future.microtask(
        () => ref.read(inspectionsNotifierProvider.notifier).loadInspections());
  }

  @override
  Widget build(BuildContext context) {
    final inspectionsState = ref.watch(inspectionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Damage Reports'),
      ),
      body: _buildBody(inspectionsState),
    );
  }

  Widget _buildBody(InspectionsState state) {
    if (state.status == InspectionsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == InspectionsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load damage reports',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref
                  .read(inspectionsNotifierProvider.notifier)
                  .loadInspections(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.inspections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'No damage reports',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'You have not created any damage reports yet.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(inspectionsNotifierProvider.notifier).loadInspections(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.inspections.length,
        itemBuilder: (context, index) {
          final inspection = state.inspections[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header rij met code en resultaat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Report #${inspection.code}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      _buildResultChip(inspection.result),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kilometerteller
                  Row(
                    children: [
                      const Icon(Icons.speed, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${inspection.odometer} km',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Datum
                  if (inspection.completed != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM dd, yyyy - HH:mm')
                              .format(inspection.completed!),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Verhuur info
                  if (inspection.rental != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.car_rental, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Rental: ${inspection.rental!.code}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (inspection.rental!.car != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.directions_car,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            '${inspection.rental!.car!.brand} ${inspection.rental!.car!.model} (${inspection.rental!.car!.licensePlate})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],

                  // Beschrijving
                  if (inspection.description != null &&
                      inspection.description!.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inspection.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Foto indicator
                  if (inspection.photo != null) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.image, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Photo attached',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultChip(String result) {
    Color color;
    String label;

    switch (result.toUpperCase()) {
      case 'OK':
        color = Colors.green;
        label = 'OK';
        break;
      case 'DAMAGED':
        color = Colors.orange;
        label = 'Damaged';
        break;
      case 'NEEDS_REPAIR':
        color = Colors.red;
        label = 'Needs Repair';
        break;
      default:
        color = Colors.grey;
        label = result;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
