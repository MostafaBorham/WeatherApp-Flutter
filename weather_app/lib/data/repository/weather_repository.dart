import 'package:weather_app/data/datasources/weather_datasource.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repository/base_weather_repository.dart';

class WeatherRepository extends BaseWeatherRepository{
  final WeatherDataSource weatherDataSource;


  WeatherRepository({required this.weatherDataSource});

  @override
  Future<Weather> getWeatherByCityName(String cityName) async{
    return await weatherDataSource.getWeatherByCountry(cityName);
  }

}