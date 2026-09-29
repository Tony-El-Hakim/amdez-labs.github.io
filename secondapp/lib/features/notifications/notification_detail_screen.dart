import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String id;

  const NotificationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification $id'),
      ),
      body: Center(
        child: Text(
          'Viewing details for notification: $id',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}