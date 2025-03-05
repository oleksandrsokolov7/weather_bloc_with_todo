import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_event.dart';
import 'package:weather_bloc_with_todo/blocs/weather/weather_state.dart';
import 'package:weather_bloc_with_todo/constants/api_constants.dart';
import 'package:weather_bloc_with_todo/models/weather_model.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final Dio dio;

  WeatherBloc(this.dio) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      // Make an API call using the constants for the request
      final Response response = await dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          'q': event.city,
          'appid': ApiConstants.apiKey,
          'units': 'metric',
          'lang': 'ua'
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the weather data from the response
        final weather = WeatherModel.fromJson(response.data);
        emit(WeatherLoaded(weather));
      } else {
        // Emit error state if unable to fetch data
        emit(const WeatherError('Failed to fetch data'));
      }
    } catch (e) {
      // Emit error state if there is an exception
      emit(WeatherError('Error: ${e.toString()}'));
    }
  }
}
