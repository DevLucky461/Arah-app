import 'dart:convert';

class People {
  int id;
  String name;

  // String email;
  String image;
  String phone;
  bool selected;
  String UUID;

  People(
      {
      this.id,
      this.name,
      // this.email,
      this.image,
      this.phone,
      this.selected,
      this.UUID});

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
        id: json['id'],
        name: json['name'],
        // email: json['email'],
        image: json['image'],
        phone: json['phone'],
        selected: false,
        UUID: "");
  }

  factory People.fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return People.fromJson(json);
  }

  String toString() {
    Map<String, dynamic> json = {
      "id": id,
      "name": name,
      // "email": email,
      "image": image,
      "phone": phone,
      "selected": selected,
      "UUID": UUID
    };
    return jsonEncode(json);
  }
}
