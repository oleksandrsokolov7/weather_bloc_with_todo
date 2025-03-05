import 'package:flutter/material.dart';

import 'task_list_page.dart'; // Экран задач
import 'weather_widget.dart'; // Экран погоды

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Индекс выбранного экрана

  final List<Widget> _pages = [
    TaskListPage(), // Экран задач
    WeatherScreen(), // Экран погоды
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task and Weather App'),
      ),
      body: _pages[_currentIndex], // Отображаем текущий экран
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Текущий индекс
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Переключение на другой экран
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks', // Элемент для задач
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather', // Элемент для погоды
          ),
        ],
      ),
    );
  }
}
