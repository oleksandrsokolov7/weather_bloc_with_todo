import 'package:equatable/equatable.dart';

// Abstract class representing a weather event
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  // Overriding props to compare instances of WeatherEvent
  List<Object?> get props => [];
}

// Event for fetching weather data for a given city
class FetchWeather extends WeatherEvent {
  final String city;

  const FetchWeather(this.city);

  @override
  // Overriding props to include the city, making instances of FetchWeather comparable
  List<Object?> get props => [city];
}
