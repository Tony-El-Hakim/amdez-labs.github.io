import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/posts/posts_screen.dart';
import '../features/posts/post_detail_screen.dart';
import '../features/notifications/notification_screen.dart';
import '../features/notifications/notification_detail_screen.dart';
import 'app_shell.dart';
import 'routes.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: Routes.posts,
    debugLogDiagnostics: true,
    
    redirect: (context, state) {
      final uri = state.uri;
      if (uri.scheme == 'postdemo' && uri.host.isNotEmpty) {
        return '/${uri.host}${uri.path}';
      }
      if(uri.path.startsWith('/tony-el-hakim-track')){
        final normalizedPath=uri.path.replaceFirst('/tony-el-hakim-track','');
        return normalizedPath.isEmpty ? '/' : normalizedPath;
      }
      return null;
    },
    routes: [

      GoRoute(
        path: '/',
        redirect: (context, state) => Routes.posts,
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.posts,
                builder: (context, state) => const PostsScreen(),
                routes: [
                  GoRoute(
                    path: ':id', // Full path: /posts/:id
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return PostDetailScreen(postId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.notifications,
                builder: (context, state) => const NotificationsScreen(),
                routes: [
                  GoRoute(
                    path: ':id', // Full path: /notifications/:id
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return NotificationDetailScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}