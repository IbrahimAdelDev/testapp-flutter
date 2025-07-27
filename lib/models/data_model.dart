class HiveData {
  final double temperature;
  final double humidity;
  final List<int> sound;
  final String deviceId;
  final String date;

  HiveData({
    required this.temperature,
    required this.humidity,
    required this.sound,
    required this.deviceId,
    required this.date,
  });

  factory HiveData.fromJson(Map<String, dynamic> json) {
    return HiveData(
      temperature: json['average']['temperature']?.toDouble() ?? 0.0,
      humidity: json['average']['humidity']?.toDouble() ?? 0.0,
      sound: List<int>.from(json['sound'] ?? []),
      deviceId: json['deviceId'] ?? 'غير معروف',
      date: json['date'] ?? '',
    );
  }

  /// ✅ تنسيق: "الثلاثاء - 5:30 صباحًا"
  String get formattedDate {
    try {
      final dt = DateTime.parse(date).toLocal();

      final weekdays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];

      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'مساءً' : 'صباحًا';

      final weekday = weekdays[(dt.weekday % 7)-1];

      return '$weekday - $hour:$minute $period';
    } catch (e) {
      return 'غير معروف';
    }
  }

  int get maxSound => sound.isNotEmpty ? sound.reduce((a, b) => a > b ? a : b) : 0;
  int get minSound => sound.isNotEmpty ? sound.reduce((a, b) => a < b ? a : b) : 0;
  int get averageSound =>
      sound.isNotEmpty ? (sound.reduce((a, b) => a + b) / sound.length).round() : 0;
}
