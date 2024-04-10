class ForecastDetails {
  final int? average;
  final String? day;
  final int? max;
  final int? min;

  ForecastDetails({this.average, this.day, this.max, this.min});

  factory ForecastDetails.fromJson(Map<String, dynamic> json) {
    return ForecastDetails(
      average: json['avg'],
      day: json['day'],
      min: json['min'],
      max: json['max'],
    );
  }
}
