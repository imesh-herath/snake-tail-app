class Hospital {
  final double lat, lang;
  final String name;

  Hospital({required this.name, required this.lat, required this.lang});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'],
      lat: json['geometry']['location']['lat'],
      lang: json['geometry']['location']['lng'],
    );
  }
}
