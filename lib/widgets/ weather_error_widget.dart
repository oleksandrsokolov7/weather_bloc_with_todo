import 'package:flutter/material.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String message;

  const WeatherErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
