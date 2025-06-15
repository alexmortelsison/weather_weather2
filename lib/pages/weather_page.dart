import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_weather2/models/weather_model.dart';
import 'package:weather_weather2/secrets.dart';
import 'package:weather_weather2/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(apiKey: apiKey);
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print("Detected city: '$cityName'");

    try {
      final weather = await _weatherService.getWeather(cityName);
      print(
        "Fetched weather: city=${weather.cityName}, temp=${weather.temperature}",
      );
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloudy.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rainy.json";
      case "thunderstorm":
        return "assets/thunderstorm.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: _weather == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading city..."),
                  SizedBox(height: 8),
                  Text("Loading weather..."),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather!.cityName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                  Text(
                    "${_weather?.temperature.round()}°C",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
