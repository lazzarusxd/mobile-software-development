import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_customize, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Painel de controle privado.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}