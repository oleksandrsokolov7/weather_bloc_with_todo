import 'package:flutter/material.dart';
import 'package:weather_bloc_with_todo/models/weather_model.dart';

class WeatherDisplayWidget extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDisplayWidget({Key? key, required this.weather})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.cityName, // Відображення назви міста
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${weather.temperature.toStringAsFixed(1)}°C', // Відображення температури в градусах Цельсія
          style: const TextStyle(fontSize: 40),
        ),
        Text(weather
            .description), // Відображення опису погоди (наприклад, "Сонячно")
        Text(
          'Вологість: ${weather.humidity}%', // Відображення вологості
        ),
        Text(
            'Швидкість вітру: ${weather.windSpeed} м/с'), // Відображення швидкості вітру в метрах на секунду
      ],
    );
  }
}
