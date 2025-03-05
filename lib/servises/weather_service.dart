import 'package:dio/dio.dart';
import 'package:weather_bloc_with_todo/constants/api_constants.dart';

import '../models/weather_model.dart';

/// Service class for fetching weather data from an external API.
class WeatherService {
  final Dio _dio = Dio();

  /// Fetches the weather for a specific city.
  /// Makes a GET request to the weather API and returns a WeatherModel object.
  /// Throws an exception if the request fails or if the status code is not 200.
  Future<WeatherModel> getWeather(String city) async {
    final response = await _dio.get(
      ApiConstants.baseUrl,
      queryParameters: {
        'q': city,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
        'lang': 'uk'
      },
    );

    // If the response status code is 200, parse the data and return a WeatherModel object.
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      // Throw an exception if there is an error with the response.
      throw Exception('Помилка завантаження погоди');
    }
  }
}
