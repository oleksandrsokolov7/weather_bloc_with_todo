import 'package:dio/dio.dart';
import 'package:weather_bloc_with_todo/constants/api_constants.dart';

import '../models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();

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

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw Exception('Помилка завантаження погоди');
    }
  }
}
