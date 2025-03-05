import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_bloc.dart';
import 'package:weather_bloc_with_todo/ui/home_page.dart';

void main() {
  final dio = Dio(); // Create Dio for HTTP requests

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(dio), // Pass Dio to the Weather BLoC
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme color
      ),
      home: HomePage(), // Home page of the app
    );
  }
}
