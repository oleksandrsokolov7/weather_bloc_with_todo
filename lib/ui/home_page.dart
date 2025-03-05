import 'package:flutter/material.dart';
import 'package:weather_bloc_with_todo/ui/weather_screen.dart';

import 'task_list_page.dart'; // Task screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Index of the currently selected screen

  // List of screens for navigation
  final List<Widget> _pages = [
    TaskListPage(), // Task screen
    WeatherScreen(), // Weather screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task and Weather App'),
      ),
      body: _pages[_currentIndex], // Display the current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Current index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Switch to the selected screen
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks', // Item for tasks
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather', // Item for weather
          ),
        ],
      ),
    );
  }
}
