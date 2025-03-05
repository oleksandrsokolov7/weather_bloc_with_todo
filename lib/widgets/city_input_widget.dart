import 'package:flutter/material.dart';

class CityInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const CityInputWidget({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Введіть місто', // Text on the input field in Ukrainian
        suffixIcon: IconButton(
          icon: const Icon(Icons.search), // Icon button for search
          onPressed: () {
            final city = controller.text.trim(); // Get the entered city
            if (city.isNotEmpty) {
              // Check if the city name is not empty
              onSearch(city); // Trigger the search with the entered city
            }
          },
        ),
      ),
    );
  }
}
