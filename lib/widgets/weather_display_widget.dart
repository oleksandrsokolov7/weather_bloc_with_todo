import 'package:flutter/material.dart';
import 'package:weather_bloc_with_todo/models/weather_model.dart';

class WeatherDisplayWidget extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDisplayWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.cityName, // Display the city name
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${weather.temperature.toStringAsFixed(1)}°C', // Display the temperature in Celsius
          style: const TextStyle(fontSize: 40),
        ),
        Text(weather
            .description), // Display the weather description (e.g., "Clear sky")
        Text(
          'Вологість: ${weather.humidity}%', // Display the humidity percentage
        ),
        Text(
            'Швидкість вітру: ${weather.windSpeed} м/с'), // Display the wind speed in meters per second
      ],
    );
  }
}
