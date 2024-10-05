// controller/weather_controller.dart
import '../bindings/home_binding.dart';

class WeatherController {
  Future<WeatherModel> getWeather(String city) async {
    return await WeatherModel.fetchWeather(city);
  }
  // Method to fetch weather by geographic coordinates
  Future<WeatherModel> getWeatherFromCoordinates(double latitude, double longitude) async {
    return await WeatherModel.fetchWeatherFromCoordinates(latitude, longitude);
  }
}
