import 'package:flutter/material.dart';
import 'package:weather_bloc_with_todo/ui/home_page.dart';
// Импорт модулей BLoC, моделей и страниц
// Import BLoC modules, models, and pages

void main() {
  // Точка входа приложения
  // Application entry point
  runApp(MyApp());
}

// Главный виджет приложения
// The main widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Указываем домашнюю страницу приложения
      // Set the home page of the application
      home: HomePage(),
    );
  }
}
