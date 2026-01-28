import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../inspections/presentation/damage_reports_screen.dart';
import '../../profile/presentation/settings_screen.dart';
import '../../rentals/presentation/rental_history_screen.dart';
import 'cars_list_screen.dart';
import 'widgets/filter_dialog.dart';

/// Startscherm met auto lijst
class HomeScreen extends ConsumerWidget {
  final bool showAppBar;

  const HomeScreen({
    super.key,
    this.showAppBar = true,
  });

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Available Cars'),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  tooltip: 'Filters',
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          if (!showAppBar)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Cars',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterDialog(context),
                    tooltip: 'Filters',
                  ),
                ],
              ),
            ),
          const Expanded(child: CarsListScreen()),
        ],
      ),
    );
  }
}
