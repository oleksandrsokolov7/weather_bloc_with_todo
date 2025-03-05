// Model class representing weather data
class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;

  // Constructor for initializing WeatherModel instance
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  // Factory method to create a WeatherModel from a JSON object
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'], // City name
      temperature: json['main']['temp'].toDouble(), // Temperature in Celsius
      description: json['weather'][0]
          ['description'], // Weather description (e.g., clear sky)
      humidity: json['main']['humidity'], // Humidity in percentage
      windSpeed: json['wind']['speed'].toDouble(), // Wind speed in m/s
      icon: json['weather'][0]['icon'], // Weather icon code
    );
  }
}
