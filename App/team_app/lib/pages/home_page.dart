
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'map_page.dart';
import 'air_quality_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elderly System Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center( 
            child: Column(
              children: [
                const Text('Welcome!', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text('Open Map (GPS)'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage())),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.timeline),
                  label: const Text('Air Quality'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AirQualityPage())),
                ),
                // you can add more menu tiles here: Sensors, Settings, Contacts, Alerts, etc.
              ],
            ),
          ),
    ),
    );
  }
}
