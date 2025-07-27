import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/get_data_sensors.dart';
import '../models/data_model.dart';
import 'package:fl_chart/fl_chart.dart';



class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Future<HiveData> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiService.fetchHiveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'بيانات الخلية',
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20
          ),
        ),
        backgroundColor: Color(0xFF222222),
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(
          // 👈 هنا
          color: Color.fromARGB(255, 255, 255, 255), // لون الأيقونة المطلوب
        ),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        toolbarTextStyle: const TextStyle(
          color: Colors.white,
        ),
        actions: const [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 96, 96, 96), // لون البوردر
            height: 0.1,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 48),
        decoration: const BoxDecoration(color: Color(0xFFFBFAF4),
        image: DecorationImage(
          image: AssetImage('images/bg.jpg'), // استخدام صورة الخلفية
          fit: BoxFit.cover, // لتغطية الكونتينر بالكامل
          alignment: Alignment.topCenter,
        ),
        ),
        
        child: FutureBuilder<HiveData>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'فشل في تحميل البيانات',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _futureData = ApiService.fetchHiveData();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFBD31),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF222222),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                              child: Text('${data.deviceId} :رقم الجهاز',style:TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20, fontWeight: FontWeight.bold,
                              ) ),
                            ),
                            Text("متوسط درجات الحرارة و معدلات الرطوبة", style:TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18, fontWeight: FontWeight.bold,
                            ) ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 0, right: 15, left: 15),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFBD31),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/heat.png',
                                            width: 150,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                            height: 120, // الطول اللي انت عايزه
                                            width: 0.5,
                                            color: Color(0xFF222222), // لون الخط
                                          ),
                                          DataCard(
                                            title: 'متوسط درجة الحرارة',
                                            value:
                                                '${data.temperature.toStringAsFixed(1)}°C',
                                                textSize: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 0, right: 15, left: 15),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFBD31),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/water.png',
                                            width: 150,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                            height: 120, // الطول اللي انت عايزه
                                            width: 0.5,
                                            color: Color(0xFF222222), // لون الخط
                                          ),
                                          DataCard(
                                            title: 'متوسط الرطوبة',
                                            value: '${data.humidity.toStringAsFixed(1)}%',
                                            textSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 15),
                              height: 1, // الطول اللي انت عايزه
                              width: 350,
                              color: Color(0xFFFFBD31), // لون الخط
                            ),
                            Text("مستويات الطنين", style:TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20, fontWeight: FontWeight.bold,
                            ) ),
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
                                child: SoundChart(soundData: data.sound),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 0, right: 15, left: 15),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFBD31),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/sound.png',
                                            width: 150,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                            height: 100, // الطول اللي انت عايزه
                                            width: 0.5,
                                            color: Color(0xFF222222), // لون الخط
                                          ),
                                          DataCard(
                                            title: 'متوسط درجات الطنين',
                                            value: '${data.averageSound} dB',
                                            textSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(' أخر تحديث يوم ${data.formattedDate}', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),)),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _futureData =
                                            ApiService.fetchHiveData(); // 👈 إعادة جلب البيانات
                                      });
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('تحديث البيانات'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFFFBD31),
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final String title;
  final String value;
  final double textSize;
  const DataCard({super.key, required this.title, required this.value, required this.textSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFFBD31),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: textSize, color: Colors.black54, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Text(
            value,
            style: TextStyle(fontSize: textSize * 1.15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
class SoundChart extends StatelessWidget {
  final List<int> soundData;

  const SoundChart({super.key, required this.soundData});

  @override
  Widget build(BuildContext context) {
    final double maxValue = soundData.reduce((a, b) => a > b ? a : b).toDouble();
    final double minValue = soundData.reduce((a, b) => a < b ? a : b).toDouble();

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
              (index) => FlSpot(index.toDouble(), soundData[index].toDouble()),
            ),
            isCurved: true,
            color: const Color(0xFFFFBD31),
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFFFBD31).withOpacity(0.3),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: maxValue,
              color: Colors.red,
              strokeWidth: 1,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topLeft,
                labelResolver: (_) => '${maxValue.toInt()} dB',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            HorizontalLine(
              y: minValue,
              color: Colors.blue,
              strokeWidth: 1,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.bottomLeft,
                labelResolver: (_) => '${minValue.toInt()} dB',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
