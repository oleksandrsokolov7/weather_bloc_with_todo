import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_bloc.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_event.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Погода')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Введіть місто',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final city = _cityController.text.trim();
                    if (city.isNotEmpty) {
                      context.read<WeatherBloc>().add(FetchWeather(city));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.weather.cityName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${state.weather.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(fontSize: 40),
                        ),
                        Text(state.weather.description),
                        Text('Вологість: ${state.weather.humidity}%'),
                        Text('Швидкість вітру: ${state.weather.windSpeed} м/с'),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                      child: Text('Введіть місто для пошуку погоди'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
