import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_app/core/utils/constants.dart';
import 'package:weather_app/data/models/weather_model.dart';

abstract class WeatherDataSource{
 Future<WeatherModel> getWeatherByCountry(String country);
}

class WeatherDataSourceApi extends WeatherDataSource{
  @override
  Future<WeatherModel> getWeatherByCountry(String country) async{
    try {
      var response = await Dio().get('${AppConstants.baseUrl}q=$country&appid=${AppConstants.appId}');
      return WeatherModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}