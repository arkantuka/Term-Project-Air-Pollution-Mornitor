class Details {
  final String? city_name;
  final String? attributions;
  final int? aqi;

  Details({
    this.city_name,
    this.attributions,
    this.aqi,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      city_name: json['city']['name'],
      attributions: json['attributions'][0]['name'],
      aqi: json['aqi'],
    );
  }
}
