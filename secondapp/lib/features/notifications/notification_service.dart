import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime receivedAt;

  AppNotification({
    required this.title,
    required this.body,
    required this.receivedAt,
  });
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<NotificationSettings> requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    return token;
  }

  void listenToMessages(void Function(AppNotification notification) onMessageReceived) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        onMessageReceived(
          AppNotification(
            title: notification.title ?? 'No Title',
            body: notification.body ?? 'No Body',
            receivedAt: DateTime.now(),
          ),
        );
      }
    });
  }
}