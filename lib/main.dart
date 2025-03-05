import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_bloc.dart';
import 'package:weather_bloc_with_todo/ui/home_page.dart';

void main() {
  final dio = Dio(); // Создаем Dio для HTTP-запросов

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(dio), // Передаем Dio в BLoC
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
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
