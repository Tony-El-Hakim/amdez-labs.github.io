import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/api_client.dart';
import 'post_repository.dart';
import 'post.dart';

part 'posts_providers.g.dart';

@riverpod
PostRepository postRepository(Ref ref) {

  final client = ref.watch(httpClientProvider);
  return PostRepository(client: client);
}

@riverpod
Future<List<Post>> postsList(Ref ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.fetchPosts();
}
@riverpod
Future<Post> postDetail(Ref ref, int id) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.fetchPostById(id);
}