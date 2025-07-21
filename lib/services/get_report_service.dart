import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {
  static Future<Map<String, dynamic>> fetchReport() async {
    final response = await http.get(Uri.parse('http://195.200.14.134:5500/api/sensors/report'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('فشل تحميل التقرير');
    }
  }
}
