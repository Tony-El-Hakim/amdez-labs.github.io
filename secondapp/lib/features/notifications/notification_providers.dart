import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'notification_service.dart';

part 'notification_providers.g.dart';

@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService();
}

@riverpod
Future<NotificationSettings> notificationPermission(Ref ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.requestPermission();
}

@riverpod
Future<String?> fcmToken(Ref ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.getToken();
}

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  List<AppNotification> build() {
    final service = ref.watch(notificationServiceProvider);

    service.listenToMessages((notification) {
      addNotification(notification);
    });

    return [];
  }

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }
}