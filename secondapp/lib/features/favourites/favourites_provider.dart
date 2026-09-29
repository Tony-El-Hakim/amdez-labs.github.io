import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourites_provider.g.dart';

@riverpod
class FavouritesNotifier extends _$FavouritesNotifier {
  @override
  Set<int> build() {
    return {};
  }

  void toggleFavourite(int postId) {
    if (state.contains(postId)) {
      state = {...state}..remove(postId);
    } else {
      state = {...state}..add(postId);
    }
  }
}