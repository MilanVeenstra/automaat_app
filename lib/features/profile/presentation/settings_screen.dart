import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/notification_providers.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// Instellingen scherm voor app voorkeuren
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // Gebruiker info sectie
          if (authState.user != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          authState.user!.displayName[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(authState.user!.displayName),
                      subtitle: Text(authState.user!.email),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],

          // Notificaties sectie
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      notificationSettings.when(
                        data: (enabled) => SwitchListTile(
                          secondary: const Icon(Icons.notifications),
                          title: const Text('Rental Reminders'),
                          subtitle: const Text(
                            'Get notified before your rental starts or ends',
                          ),
                          value: enabled,
                          onChanged: (value) {
                            ref
                                .read(notificationSettingsProvider.notifier)
                                .toggleNotifications(value);
                          },
                        ),
                        loading: () => const ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Rental Reminders'),
                          subtitle: Text('Loading...'),
                          trailing: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Rental Reminders'),
                          subtitle: Text('Error: ${error.toString()}'),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: const Text('Test Notification'),
                        subtitle: const Text('Send a test notification'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          await ref
                              .read(notificationSettingsProvider.notifier)
                              .showTestNotification();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Test notification sent!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // App info sectie
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Version'),
                        subtitle: Text('1.0.0+1'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .logout();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
