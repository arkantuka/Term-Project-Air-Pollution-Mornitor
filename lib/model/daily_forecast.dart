class DailyForecastDetails {
  final int? daily_pm25;
  final int? daily_pm10;
  final int? daily_o3;

  DailyForecastDetails({
    this.daily_pm25,
    this.daily_pm10,
    this.daily_o3,
  });

  factory DailyForecastDetails.fromJson(Map<String, dynamic> json) {
    return DailyForecastDetails(
      daily_pm25: json['pm25'][8]['avg'],
      daily_pm10: json['pm10'][8]['avg'],
      daily_o3: json['o3'][7]['avg'],
    );
  }
}
