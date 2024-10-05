// view/weather_view.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/home_controller.dart';
import '../bindings/home_binding.dart';


class WeatherView extends StatefulWidget {
  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final WeatherController _controller = WeatherController();
  WeatherModel? _weather;
  bool _isLoading = false;
  final TextEditingController _cityController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  void _getCurrentLocationWeather() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _getWeatherFromCoordinates(position.latitude, position.longitude);
  }

  void _getWeatherFromCoordinates(double latitude, double longitude) async {
    setState(() {
      _isLoading = true;
    });

    try {
      WeatherModel weather = await _controller.getWeatherFromCoordinates(latitude, longitude);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load weather data')));
    }
  }

  void _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      WeatherModel weather = await _controller.getWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load weather data')));
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  Color _getBackgroundColor() {
    if (_weather?.condition == 'Sunny') return Colors.yellowAccent.shade100;
    if (_weather?.condition == 'Rainy') return Colors.blueGrey.shade100;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getBackgroundColor(), Colors.blueGrey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Centered city name display
            Center(
              child: Text(
                _weather?.city ?? 'Enter a city',
                style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: _toggleSearch,
                  child: Icon(
                    Icons.search,
                    color: Colors.blueGrey[700],
                    size: 30,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _isSearchVisible
                      ? TextField(
                          controller: _cityController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter City Name',
                            hintStyle: TextStyle(color: Colors.blueGrey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search, color: Colors.blueGrey[700]),
                              onPressed: _getWeather,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _weather == null
                    ? Center(child: Text('No data available', style: TextStyle(color: Colors.black, fontSize: 20)))
                    : Expanded(
                        child: ListView(
                          children: [
                            _buildWeatherCard(
                              icon: Icons.thermostat,
                              title: 'Temperature',
                              value: '${_weather?.temperature ?? 0} °C',
                            ),
                            _buildWeatherCard(
                              icon: Icons.wb_sunny,
                              title: 'Condition',
                              value: _weather?.condition ?? '',
                            ),
                            _buildWeatherCard(
                              icon: Icons.air,
                              title: 'Wind Speed',
                              value: '${_weather?.windSpeed ?? 0} m/s',
                            ),
                            _buildWeatherCard(
                              icon: Icons.umbrella,
                              title: 'Precipitation',
                              value: '${_weather?.precipitation ?? 0} mm',
                            ),
                            _buildWeatherCard(
                              icon: Icons.water,
                              title: 'Humidity',
                              value: '${_weather?.humidity ?? 0}%',
                            ),
                            _buildWeatherCard(
                              icon: Icons.cloud,
                              title: 'Cloud Coverage',
                              value: '${_weather?.cloudCoverage ?? 0}%',
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard({required IconData icon, required String title, required String value}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.blueGrey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey[700], size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.blueGrey[800], fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}