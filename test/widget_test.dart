import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_bloc_with_todo/main.dart';

void main() {
  testWidgets('Weather app displays weather information correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the city name, temperature, and weather description are not empty.
    expect(find.text('City Name'),
        findsNothing); // Replace with an actual city name if possible
    expect(find.text('Temperature'),
        findsNothing); // Replace with actual expected temp
    expect(find.text('Description'),
        findsNothing); // Replace with actual weather description

    // Simulate the user entering a city and pressing the search button
    // For example, if you have a search button or text field, you would interact with them like this:

    // Enter a city into the text field
    await tester.enterText(find.byType(TextField), 'Kyiv');
    await tester.tap(find.byIcon(Icons.search));

    // Trigger a frame to update the UI
    await tester.pump();

    // After tapping the search button, check that relevant weather information appears
    expect(
        find.text('Kyiv'), findsOneWidget); // Check that city name is displayed
    expect(find.text('Temperature'),
        findsOneWidget); // Check that temperature is displayed
    expect(find.text('Description'),
        findsOneWidget); // Check that description is displayed

    // You may also want to verify specific text values, e.g.:
    // expect(find.text('Temperature: 25°C'), findsOneWidget);
  });
}
