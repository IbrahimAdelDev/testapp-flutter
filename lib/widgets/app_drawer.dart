import 'package:flutter/material.dart';
import '../screens/data_page.dart' as data_page;
import '../screens/reports_page.dart';
import '../screens/recommendations_page.dart';
import '../screens/blog_page.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF222222)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/BeeAware.png',
                  width: 90,
                ),
                Text('BeeAware', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            )
          ),
          ListTile(
            title: const Text('بيانات الخلية'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const data_page.DataPage())),
          ),
          ListTile(
            title: const Text('المجتمع'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BlogPage())),
          ),
          ListTile(
            title: const Text('نصائح و توصيات'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendationsPage())),
          ),
          ListTile(
            title: const Text('تقارير الخلية'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportPage())),
          ),
        ],
      ),
    );
  }
}
