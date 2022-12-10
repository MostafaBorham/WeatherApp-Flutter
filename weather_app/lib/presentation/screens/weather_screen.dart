import 'package:flutter/material.dart';
import 'package:weather_app/core/enums/weather_types.dart';
import 'package:weather_app/core/utils/constants.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/usecases/get_weather_by_country_name.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({
    Key? key,
    required this.getWeatherUseCase,
  }) : super(key: key);
  final GetWeatherByCountryNameUseCase getWeatherUseCase;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherCityController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Weather? _weather;
  bool _isWeatherLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(AppConstants.weatherTitle),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            _getWeatherBackgroundUrl(_getWeatherType(
                _weather != null ? _weather!.main : AppConstants.emptyString)!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: _weatherCityController,
                      maxLines: 1,
                      validator: (cityInput) {
                        if (cityInput!.isEmpty) {
                          return 'should enter city!';
                        }
                        return null;
                      },
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black54,
                            )),
                      ),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54, width: 2)),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isWeatherLoading = true;
                          });
                          await widget.getWeatherUseCase
                              .execute(_weatherCityController.text)
                              .then((weather) {
                            setState(() {
                              _weather = weather;
                              _isWeatherLoading = false;
                            });
                          }).catchError((error) {
                            setState(() {
                              _isWeatherLoading = false;
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                    content: Text(
                                        '${_weatherCityController.text} is not found!')));
                            });
                          });
                        }
                      },
                      child: _isWeatherLoading
                          ? const CircularProgressIndicator(color: Colors.white,)
                          : Text(
                              'Show Weather',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                            ))),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 2)),
                child: _weather != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  style: Theme.of(context).textTheme.titleLarge,
                                  _weather!.id.toString()),
                              Text(
                                  style: Theme.of(context).textTheme.titleLarge,
                                  _weather!.cityName)
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  style: Theme.of(context).textTheme.titleLarge,
                                  _weather!.description),
                              Text(
                                  style: Theme.of(context).textTheme.titleLarge,
                                  _weather!.pressure.toString())
                            ],
                          ),
                        ],
                      )
                    : Text(
                        'No Weather Data',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }

  WeatherTypes? _getWeatherType(String type) {
    WeatherTypes? weatherType;
    if (type == 'Clear') {
      weatherType = WeatherTypes.sunny;
    } else if (type == 'Clouds') {
      weatherType = WeatherTypes.cloudy;
    } else if (type == 'Mist') {
      weatherType = WeatherTypes.partialCloudy;
    } else if (type == AppConstants.emptyString) {
      weatherType = WeatherTypes.noWeather;
    } else {
      weatherType = WeatherTypes.rainy;
    }
    return weatherType;
  }

  String _getWeatherBackgroundUrl(WeatherTypes weatherType) {
    switch (weatherType) {
      case WeatherTypes.sunny:
        return AppConstants.sunnyBackgroundUrl;
      case WeatherTypes.cloudy:
        return AppConstants.cloudyBackgroundUrl;
      case WeatherTypes.partialCloudy:
        return AppConstants.partialCloudyBackgroundUrl;
      case WeatherTypes.rainy:
        return AppConstants.rainyBackgroundUrl;
      case WeatherTypes.noWeather:
        return AppConstants.noWeatherBackgroundUrl;
    }
  }
}
