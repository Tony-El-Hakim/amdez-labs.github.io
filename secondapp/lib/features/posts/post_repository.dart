import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class PostRepository {
  final http.Client _client;

  PostRepository({required this._client});

  // fetching
  Future<List<Post>> fetchPosts() async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final http.Response response = await _client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((jsonItem) => Post.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
  Future<Post> fetchPostById(int id) async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final http.Response response = await _client.get(url);

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post detail');
    }
  }
}