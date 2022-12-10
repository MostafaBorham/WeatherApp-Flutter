import 'package:flutter/material.dart';
import 'package:weather_app/data/datasources/weather_datasource.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/domain/usecases/get_weather_by_country_name.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final weatherDataSourceApi = WeatherDataSourceApi();
  final weatherRepo =
      WeatherRepository(weatherDataSource: weatherDataSourceApi);
  final getWeatherUseCase =
      GetWeatherByCountryNameUseCase(baseWeatherRepository: weatherRepo);
  runApp(MyApp(
    getWeatherUseCase: getWeatherUseCase,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.getWeatherUseCase,
  });
  final GetWeatherByCountryNameUseCase getWeatherUseCase;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
              titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ))),
      home: WeatherScreen(getWeatherUseCase: getWeatherUseCase),
    );
  }
}
