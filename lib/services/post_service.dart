import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_api/pages/home_page_stateless_future_builder.dart';

class PostService {
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
