import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// Profiel scherm
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        children: [
          // Gebruiker Info Header
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user?.firstName?.substring(0, 1).toUpperCase() ??
                    user?.login?.substring(0, 1).toUpperCase() ??
                    'U',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? user?.login ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Instellingen Sectie
          _buildSectionHeader(context, 'Preferences'),
          _buildListTile(
            context,
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'App preferences and notifications',
            onTap: () => context.push(AppRoutes.settings),
          ),

          const Divider(height: 1),

          // Rapporten Sectie
          _buildSectionHeader(context, 'Reports'),
          _buildListTile(
            context,
            icon: Icons.report_problem,
            title: 'My Damage Reports',
            subtitle: 'View and manage damage reports',
            onTap: () => context.push(AppRoutes.damageReports),
          ),

          const Divider(height: 1),

          // Account Sectie
          _buildSectionHeader(context, 'Account'),
          _buildListTile(
            context,
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _showLogoutDialog(context, ref),
          ),

          const SizedBox(height: 24),

          // App Info
          Center(
            child: Column(
              children: [
                Text(
                  'AutoMaat v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Car Rental Made Simple',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authNotifierProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
