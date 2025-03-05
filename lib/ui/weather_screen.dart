import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_bloc.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_event.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_state.dart';
import 'package:weather_bloc_with_todo/widgets/%20weather_error_widget.dart';

import 'package:weather_bloc_with_todo/widgets/city_input_widget.dart';
import 'package:weather_bloc_with_todo/widgets/weather_display_widget.dart';

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
      appBar: AppBar(title: const Text('Погода')), // Title in Ukrainian
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Widget for entering city name
            CityInputWidget(
              controller: _cityController,
              onSearch: (city) {
                context.read<WeatherBloc>().add(FetchWeather(city));
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  // Weather is loading, show loading spinner
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Weather data loaded, display the weather details
                  else if (state is WeatherLoaded) {
                    return WeatherDisplayWidget(weather: state.weather);
                  }
                  // Weather loading failed, show error message
                  else if (state is WeatherError) {
                    return WeatherErrorWidget(message: state.message);
                  }
                  // If no city is entered, show a prompt
                  return const Center(
                      child: Text(
                          'Введіть місто для пошуку погоди')); // UI text in Ukrainian
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
