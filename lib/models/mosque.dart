class Mosques {
  String mosque_name;
  String mosque_image;
  double latitude;
  double longitude;
  double distance;

  Mosques({
    this.mosque_name,
    this.mosque_image,
    this.latitude,
    this.longitude,
    this.distance,
  });

  factory Mosques.fromJson(Map<String, dynamic> json) {
    return Mosques(
      mosque_name: json['mosque_name'],
      mosque_image: json['mosque_image'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      distance: json['distance'],
    );
  }
}
