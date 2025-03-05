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
      final response = await dio.get(
        ApiConstants.baseUrl, // Используем константы
        queryParameters: {
          'q': event.city,
          'appid': ApiConstants.apiKey,
          'units': 'metric',
          'lang': 'ua'
        },
      );

      if (response.statusCode == 200) {
        final weather = WeatherModel.fromJson(response.data);
        emit(WeatherLoaded(weather));
      } else {
        emit(const WeatherError('Не вдалося отримати дані'));
      }
    } catch (e) {
      emit(WeatherError('Помилка: ${e.toString()}'));
    }
  }
}
