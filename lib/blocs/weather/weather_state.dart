import 'package:equatable/equatable.dart';
import 'package:weather_bloc_with_todo/models/weather_model.dart';

// Abstract class representing the weather states
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  // Overriding props to compare instances of WeatherState
  List<Object?> get props => [];
}

// Initial state, before any data is fetched
class WeatherInitial extends WeatherState {}

// Loading state, indicating that data is being fetched
class WeatherLoading extends WeatherState {}

// Loaded state, representing successful data fetching
class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded(this.weather);

  @override
  // Including weather in the props to make WeatherLoaded comparable
  List<Object?> get props => [weather];
}

// Error state, representing a failure in fetching weather data
class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  // Including message in the props to make WeatherError comparable
  List<Object?> get props => [message];
}
