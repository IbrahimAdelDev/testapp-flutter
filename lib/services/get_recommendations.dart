import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  static Future<List<String>> fetchRecommendations() async {
    final response = await http.get(Uri.parse('http://195.200.14.134:5500/api/sensors/recommendation'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> recommendations = data['result']['recommendations'];
      return recommendations.cast<String>();
    } else {
      throw Exception('فشل في تحميل التوصيات');
    }
  }
}
