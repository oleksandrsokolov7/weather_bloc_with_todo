import 'package:flutter/material.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String message;

  const WeatherErrorWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
