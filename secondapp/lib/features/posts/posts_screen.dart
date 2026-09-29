import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import 'posts_providers.dart';
import '../favourites/favourites_provider.dart';


class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsListProvider);
    final favourites = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts (Favourites: ${favourites.length})'),
      ),
      body: postsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(postsListProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (posts) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(postsListProvider);
            await ref.read(postsListProvider.future);
          },
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final isFavourite = favourites.contains(post.id);

              return ListTile(
                leading: CircleAvatar(
                  child: Text('${post.id}'),
                ),
                title: Text(post.title),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  context.go(Routes.postDetail(post.id));
                },
                trailing: IconButton(
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: isFavourite ? Colors.red : null,
                  ),
                  onPressed: () {
                    ref
                        .read(favouritesProvider.notifier)
                        .toggleFavourite(post.id);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}