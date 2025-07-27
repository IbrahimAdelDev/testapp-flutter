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
                    // print the error for debugging purposes
                    print('Error fetching report: ${snapshot.error}');
                    return Center(
                      child: Text(
                        'فشل تحميل التقرير: ${snapshot.error.toString()}', // Show error for debugging
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final data = snapshot.data!;
                  final List<dynamic> chartData = data['data_sent_to_ai'] ?? []; // Ensure it's a list, default to empty
                  final report = data['report'] ?? {}; // Default to empty map

                  // Collect data lists
                  List<double> temperatureList = [];
                  List<double> humidityList = [];
                  List<double> soundList = [];

                  for (var entry in chartData) {
                    if (entry['average'] != null) {
                      // Only add if temperature/humidity are not null
                      final temp = (entry['average']['temperature'] as num?);
                      final hum = (entry['average']['humidity'] as num?);

                      if (temp != null) {
                         temperatureList.add(temp.toDouble());
                      } else {
                         temperatureList.add(0.0); // Or handle as null, but charts usually need numbers
                      }
                      if (hum != null) {
                         humidityList.add(hum.toDouble());
                      } else {
                         humidityList.add(0.0); // Or handle as null
                      }
                    }
                    if (entry['sound'] != null) {
                      // Ensure sound is actually a List before mapping
                      if (entry['sound'] is List) {
                        soundList.addAll((entry['sound'] as List).map((e) => (e as num).toDouble()));
                      }
                    }
                  }

                  // Handle empty lists for charting gracefully
                  // If lists are empty, reduce will throw an error. Provide default min/max
                  final double tempMaxValue = temperatureList.isNotEmpty ? temperatureList.reduce((a, b) => a > b ? a : b) : 0.0;
                  final double tempMinValue = temperatureList.isNotEmpty ? temperatureList.reduce((a, b) => a < b ? a : b) : 0.0;
                  final double humMaxValue = humidityList.isNotEmpty ? humidityList.reduce((a, b) => a > b ? a : b) : 0.0;
                  final double humMinValue = humidityList.isNotEmpty ? humidityList.reduce((a, b) => a < b ? a : b) : 0.0;
                  final double soundMaxValue = soundList.isNotEmpty ? soundList.reduce((a, b) => a > b ? a : b) : 0.0;
                  final double soundMinValue = soundList.isNotEmpty ? soundList.reduce((a, b) => a < b ? a : b) : 0.0;


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

                            // Temperature Chart
                            Text('مستويات الحرارة', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                            ChartContainer(
                              child: SoundChart(
                                // Use the collected temperatureList here
                                soundData: temperatureList,
                                color: Colors.red,
                                maxLabel: "°C",
                                minLabel: "°C",
                                // Pass the actual min/max values to the chart for better scaling
                                minY: (tempMinValue > 0 && tempMinValue < 10) ? 0.0 : (tempMinValue * 0.95), // Adjust min for better visualization
                                maxY: tempMaxValue * 1.05, // Adjust max for better visualization
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Humidity Chart
                            Text('مستويات الرطوبة', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                            ChartContainer(
                              child: SoundChart(
                                // Use the collected humidityList here
                                soundData: humidityList,
                                color: Colors.blue,
                                maxLabel: "%",
                                minLabel: "%",
                                minY: (humMinValue > 0 && humMinValue < 10) ? 0.0 : (humMinValue * 0.95), // Adjust min for better visualization
                                maxY: humMaxValue * 1.05, // Adjust max for better visualization
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sound Chart
                            Text('مستويات الطنين', style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
                            ChartContainer(
                              child: SoundChart(
                                // Use the collected soundList here
                                soundData: soundList,
                                color: Colors.green,
                                maxLabel: "dB", // Assuming dB for sound level
                                minLabel: "dB",
                                minY: (soundMinValue > 0 && soundMinValue < 100) ? 0.0 : (soundMinValue * 0.95), // Adjust min for sound visualization
                                maxY: soundMaxValue * 1.05, // Adjust max for sound visualization
                              ),
                            ),

                            const SizedBox(height: 20),
                            // Report Summary
                            Text(
                              'القراءات الطبيعية: ${report['normal_readings'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'القراءات الغير طبيعية: ${report['abnormal_readings'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'الملخص: ${report['summary'] ?? 'لا يوجد ملخص متاح.'}',
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

// Helper Widget for Chart Container styling
class ChartContainer extends StatelessWidget {
  final Widget child;
  const ChartContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 66, 64, 64),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFBD31),
          width: 1,
        ),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(top: 65), // Adjusted padding to provide space for labels
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 66, 64, 64),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child, // Pass the chart widget directly
      ),
    );
  }
}


class SoundChart extends StatelessWidget {
  final List<double> soundData;
  final Color color;
  final String? maxLabel;
  final String? minLabel;
  final double? minY; // Add minY
  final double? maxY; // Add maxY


  const SoundChart({
    super.key,
    required this.soundData,
    required this.color,
    this.maxLabel,
    this.minLabel,
    this.minY, // Initialize minY
    this.maxY, // Initialize maxY
  });

  @override
  Widget build(BuildContext context) {
    // Calculate min/max values only if not provided by parent, otherwise use provided
    final double calculatedMinY = minY ?? (soundData.isNotEmpty ? (soundData.reduce((a, b) => a < b ? a : b) * 0.9) : 0.0);
    final double calculatedMaxY = maxY ?? (soundData.isNotEmpty ? (soundData.reduce((a, b) => a > b ? a : b) * 1.1) : 100.0);

    // Handle empty data: show a placeholder or adjust min/max to prevent errors
    if (soundData.isEmpty) {
      return Center(
        child: Text(
          'لا توجد بيانات متاحة لهذا الرسم البياني.',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    return LineChart(
      LineChartData(
        minY: calculatedMinY, // Use calculated or provided minY
        maxY: calculatedMaxY, // Use calculated or provided maxY
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
              y: calculatedMaxY, // Use calculated or provided maxY for the label
              color: Colors.red,
              strokeWidth: 1,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topLeft,
                labelResolver: (_) => '${calculatedMaxY.toStringAsFixed(1)} ${maxLabel ?? ''}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            HorizontalLine(
              y: calculatedMinY, // Use calculated or provided minY for the label
              color: Colors.blue,
              strokeWidth: 1,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.bottomLeft,
                labelResolver: (_) => '${calculatedMinY.toStringAsFixed(1)} ${minLabel ?? ''}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}