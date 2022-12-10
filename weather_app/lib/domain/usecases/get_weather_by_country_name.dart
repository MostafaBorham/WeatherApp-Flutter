import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repository/base_weather_repository.dart';

class GetWeatherByCountryNameUseCase{
  final BaseWeatherRepository baseWeatherRepository;

  GetWeatherByCountryNameUseCase({required this.baseWeatherRepository});

  Future<Weather> execute(String cityName)async{
    return await baseWeatherRepository.getWeatherByCityName(cityName);
  }
}