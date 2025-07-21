import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostService {
  static Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse('http://195.200.14.134:5500/api/sensors/posts'));
    print(response.body); // Debugging line to check the response
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception('فشل في تحميل البوستات');
    }
  }
}
