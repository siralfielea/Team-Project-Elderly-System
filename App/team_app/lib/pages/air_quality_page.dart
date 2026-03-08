
import 'package:flutter/material.dart';

class AirQualityPage extends StatelessWidget {
  const AirQualityPage({super.key});

  @override
  Widget build(BuildContext context) {
const overallAirQuality = 'Good';
const co2Levels = 'Low';
    return Scaffold(
      appBar: AppBar(title: const Text('Air Quality')),
      body: ListView(

        children: [
        Text('Overall Air Quality: $overallAirQuality'),
        Text('CO2 Levels: $co2Levels'),
        ],
      ),
    );
  }
}
