class Weather {
  final int id;
  final String cityName;
  final String main;
  final String description;
  final int pressure;

  Weather(
      {required this.id,
      required this.cityName,
      required this.main,
      required this.description,
      required this.pressure});

  @override
  String toString() {
    return 'id=$id - city=$cityName - main=$main - description=$description - pressure=$pressure';
  }
}
