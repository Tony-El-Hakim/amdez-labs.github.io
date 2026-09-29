import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// IMPORTANT: Replace 'your_app_name' with the exact 'name:' from your pubspec.yaml
import 'package:secondapp/features/posts/posts_screen.dart';
import 'package:secondapp/features/posts/post_repository.dart';
import 'package:secondapp/features/posts/post.dart';
import 'package:secondapp/features/posts/posts_providers.dart';
import 'package:secondapp/features/notifications/notification_providers.dart';
import 'package:secondapp/features/notifications/notification_service.dart';

// 1. Fake Success Repository
class FakePostRepository implements PostRepository {
  @override
  Future<List<Post>> fetchPosts() async {
    return [
      Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Body 1'),
      Post(id: 2, userId: 1, title: 'Test Post 2', body: 'Body 2'),
    ];
  }

  @override
  Future<Post> fetchPostById(int id) async {
    return Post(id: id, userId: 1, title: 'Test Post $id', body: 'Body $id');
  }
}

// 2. Fake Error Repository
class ErrorPostRepository implements PostRepository {
  @override
  Future<List<Post>> fetchPosts() async {
    throw Exception('Failed to load posts');
  }

  @override
  Future<Post> fetchPostById(int id) async {
    throw Exception('Failed to load post detail');
  }
}

// 3. Fake Notifications Notifier (prevents Firebase Messaging from running in tests)
class FakeNotificationsNotifier extends NotificationsNotifier {
  @override
  List<AppNotification> build() {
    return []; // Return empty notifications list safely without Firebase
  }
}

void main() {
  testWidgets('PostsScreen displays fixed list successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postRepositoryProvider.overrideWithValue(FakePostRepository()),
          notificationsProvider.overrideWith(() => FakeNotificationsNotifier()),
        ],
        child: const MaterialApp(
          home: PostsScreen(),
        ),
      ),
    );

    // Allow async providers to resolve
    await tester.pumpAndSettle();

    // Verify UI items
    expect(find.text('Test Post 1'), findsOneWidget);
    expect(find.text('Test Post 2'), findsOneWidget);
  });

  testWidgets('PostsScreen displays error UI when repository throws', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postRepositoryProvider.overrideWithValue(ErrorPostRepository()),
          notificationsProvider.overrideWith(() => FakeNotificationsNotifier()),
        ],
        child: const MaterialApp(
          home: PostsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify error UI elements
    expect(find.textContaining('Error:'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}