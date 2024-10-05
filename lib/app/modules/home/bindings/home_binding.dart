// model/weather_model.dart
import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final double windSpeed; // New field for wind speed
  final double precipitation; // New field for precipitation
  final double humidity; // New field for humidity
  final double cloudCoverage; // New field for cloud coverage
  
  
  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.windSpeed, // Initialize wind speed
    required this.precipitation, // Initialize precipitation
    required this.humidity, // Initialize humidity
    required this.cloudCoverage, // Initialize cloud coverage
  });

  // Fetch weather data by city name
  static Future<WeatherModel> fetchWeather(String city) async {
    final apiKey = 'cb0666e4560e118531f9748ca1c9021e'; // Replace with your OpenWeatherMap API key
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel(
        city: data['name'],
        temperature: data['main']['temp'],
        condition: data['weather'][0]['main'],
        windSpeed: data['wind']['speed'], // Parse wind speed from JSON
        precipitation: data['rain']?['1h'] ?? 0.0, // Parse precipitation from JSON
        humidity: data['main']['humidity'], // Parse humidity from JSON
        cloudCoverage: data['clouds']['all'].toDouble(), // Parse cloud coverage from JSON
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch weather data by coordinates
  static Future<WeatherModel> fetchWeatherFromCoordinates(double latitude, double longitude) async {
    final apiKey = 'cb0666e4560e118531f9748ca1c9021e'; // Replace with your OpenWeatherMap API key
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel(
        city: data['name'],
        temperature: data['main']['temp'],
        condition: data['weather'][0]['main'],
        windSpeed: data['wind']['speed'], // Parse wind speed from JSON
        precipitation: data['rain']?['1h'] ?? 0.0, // Parse precipitation from JSON
        humidity: data['main']['humidity'], // Parse humidity from JSON
        cloudCoverage: data['clouds']['all'].toDouble(), // Parse cloud coverage from JSON
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  
}