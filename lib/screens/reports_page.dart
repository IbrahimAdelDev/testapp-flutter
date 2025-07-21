import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/app_drawer.dart';
import '../services/get_report_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<Map<String, dynamic>> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = ReportService.fetchReport();
  }



  @override
Widget build(BuildContext context) {
  return Theme(
    data: Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    ),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('تقرير الخلية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color(0xFF222222),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder<Map<String, dynamic>>(
              future: _reportFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'فشل تحميل التقرير',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                }

                final data = snapshot.data!;
                final chartData = data['data'];
                final report = data['report'];

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 50, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('تقرير عن حالة الخلية في أخر ساعة', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                          const SizedBox(height: 20),
                          Text('مستويات الحرارة', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 66, 64, 64),
                                  borderRadius: BorderRadius.circular(16), // استدارة الزوايا
                                  border: Border.all(
                                    color: Color(0xFFFFBD31), // لون البوردر
                                    width: 1, // سمك البوردر
                                  ),
                                ),
                              child: Container(
                                height: 200,
                                padding: const EdgeInsets.only(top: 65),
                                clipBehavior: Clip.hardEdge, // 👈 تمنع المحتوى من الخروج
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 66, 64, 64),
                                  borderRadius: BorderRadius.circular(16), // استدارة الزوايا
                                ),
                                child: SoundChart(
                                  soundData: (chartData['temperature'] as List)
                                      .map((e) => (e as num).toDouble())
                                      .toList(),
                                  color: Colors.red,
                                  maxLabel: "°C",
                                  minLabel: "°C",
                                ),


                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('مستويات الرطوبة', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 66, 64, 64),
                                  borderRadius: BorderRadius.circular(16), // استدارة الزوايا
                                  border: Border.all(
                                    color: Color(0xFFFFBD31), // لون البوردر
                                    width: 1, // سمك البوردر
                                  ),
                                ),
                              child: Container(
                                height: 200,
                                padding: const EdgeInsets.only(top: 65),
                                clipBehavior: Clip.hardEdge, // 👈 تمنع المحتوى من الخروج
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 66, 64, 64),
                                  borderRadius: BorderRadius.circular(16), // استدارة الزوايا
                                ),
                                child: SoundChart(
                                  soundData: (chartData['humidity'] as List)
                                      .map((e) => (e as num).toDouble())
                                      .toList(),
                                  color: Colors.blue,
                                  maxLabel: "%",
                                  minLabel: "%",
                                ),


                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('مستويات الطنين', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 66, 64, 64),
                                  borderRadius: BorderRadius.circular(16), // استدارة الزوايا
                                  border: Border.all(
                                    color: Color(0xFFFFBD31), // لون البوردر
                                    width: 1, // سمك البوردر
                                  ),
                                ),
                              child: Container(
                                height: 200,
                                padding: const EdgeInsets.only(top: 65),
                                clipBehavior: Clip.hardEdge, // 👈 تمنع المحتوى من الخروج
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 66, 64, 64),
                                  borderRadius: BorderRadius.circular(16), // استدارة الزوايا
                                ),
                                child: SoundChart(
                                  soundData: (chartData['sound'] as List)
                                      .map((e) => (e as num).toDouble())
                                      .toList(),
                                  color: Colors.green,
                                  maxLabel: "dB",
                                  minLabel: "dB",
                                ),


                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('القراءات الطبيعية: ${report['normal_readings']}', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                            Text('القراءات الغير طبيعية: ${report['abnormal_readings']}', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                            const SizedBox(height: 20),
                            Text(
                              'الملخص: ${report['summary']}',
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}

}


class SoundChart extends StatelessWidget {
  final List<double> soundData;
  final Color color;
  final String? maxLabel;
  final String? minLabel;

  const SoundChart({
    super.key,
    required this.soundData,
    required this.color,
    this.maxLabel,
    this.minLabel,
  });

  @override
  Widget build(BuildContext context) {
    final double maxValue1 = soundData.reduce((a, b) => a > b ? a : b);
    final double minValue1 = soundData.reduce((a, b) => a < b ? a : b);

    return LineChart(
      LineChartData(
        minY: 0,
        backgroundColor: const Color(0xFF323232),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              soundData.length,
              (index) => FlSpot(index.toDouble(), soundData[index]),
            ),
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.3),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: maxValue1,
              color: Colors.red,
              strokeWidth: 1,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topLeft,
                labelResolver: (_) => '${maxValue1.toStringAsFixed(1)} ${maxLabel ?? ''}',

                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            HorizontalLine(
              y: minValue1,
              color: Colors.blue,
              strokeWidth: 1,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.bottomLeft,
                labelResolver: (_) => '${minValue1.toStringAsFixed(1)} ${minLabel ?? ''}',

                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
