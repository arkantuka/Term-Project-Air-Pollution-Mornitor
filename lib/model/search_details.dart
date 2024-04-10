class SearchDetails {
  final String? station_name;
  final String? aqi;
  final String? checking_time;
  final String? time_zone;
  final String url;

  SearchDetails(
      {this.station_name,
      this.aqi,
      this.checking_time,
      this.time_zone,
      required this.url});

  factory SearchDetails.fromJson(Map<String, dynamic> json) {
    return SearchDetails(
      station_name: json['station']['name'],
      aqi: json['aqi'],
      checking_time: json['time']['stime'],
      time_zone: json['time']['tz'],
      url: json['station']['url'],
    );
  }
}
