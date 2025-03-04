import 'package:flutter/material.dart';
// Импорт пакета для управления состоянием с использованием BLoC (будет использован позже)
// Import the package for state management with BLoC (to be used later)

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Запуск приложения
  // Entry point of the application
  runApp(MyApp());
}

// Главный виджет приложения
// The main widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Заголовок приложения
      // Application title
      title: 'Task Manager',
      // Тема приложения
      // Application theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Главная страница приложения
      // Home page of the application
      home: HomePage(),
    );
  }
}

// Домашняя страница, где будет отображаться список задач и информация о погоде
// Home page where the task list and weather information will be displayed
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar с названием приложения
      // AppBar with the application title
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      // Основное содержимое страницы
      // Main content of the page
      body: Center(
        child: Text(
          'Hello, Task Manager!',
          // Приветственное сообщение, которое можно заменить на список задач
          // Welcome message, can be later replaced with the task list
        ),
      ),
    );
  }
}
