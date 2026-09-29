import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../favourites/favourites_provider.dart';
import 'notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final favourites = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications (Favourites: ${favourites.length})'),
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications received yet.\nSend one from Firebase Console!',
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            leading: const Icon(
              Icons.notifications_active,
              color: Colors.orange,
            ),
            title: Text(notif.title),
            subtitle: Text(notif.body),
          );
        },
      ),
    );
  }
}