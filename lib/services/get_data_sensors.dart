import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';

class ApiService {
  static Future<HiveData> fetchHiveData() async {
    final response = await http.get(Uri.parse('http://195.200.14.134:5500/api/sensors/averages'));
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final hiveJson = jsonResponse['data']; // 🟢 هنا التعديل
      // ignore: avoid_print
      // print(hiveJson);
      return HiveData.fromJson(hiveJson);
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }
}
