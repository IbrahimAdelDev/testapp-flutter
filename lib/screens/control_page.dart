import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحكم')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('صفحة التحكم')),
    );
  }
}
