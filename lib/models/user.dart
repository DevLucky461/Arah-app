class User {
  int id;
  String name;
  String full_name;
  String email;
  String phone;
  String image;
  String nric;
  String nu_member;
  String dob;
  String gender;
  String occupation;
  String income;
  String country;
  String state;
  String address_key;
  String public_key;

  User();

  User.map(dynamic obj) {
    if (obj != null) {
      this.id = obj["id"];
      this.name = obj["name"];
      this.full_name = obj["full_name"];
      this.email = obj["email"];
      this.phone = obj["phone"];
      this.image = obj["image"];
      this.nric = obj["nric"];
      this.nu_member = obj["nu_member"];
      this.dob = obj["dob"];
      this.gender = obj["gender"];
      this.occupation = obj["occupation"];
      this.income = obj["income"];
      this.country = obj["country"];
      this.state = obj["state"];
      this.address_key = obj["address_key"];
      this.public_key = obj["public_key"];
    }
  }

  Map toMap() {
    Map<String, dynamic> map = new Map();
    map["id"] = id;
    map["name"] = name;
    map["full_name"] = full_name;
    map["email"] = email;
    map["phone"] = phone;
    map["image"] = image;
    map["nric"] = nric;
    map["nu_member"] = nu_member;
    map["dob"] = dob;
    map["gender"] = gender;
    map["occupation"] = occupation;
    map["income"] = income;
    map["country"] = country;
    map["state"] = state;
    map["address_key"] = address_key;
    map["public_key"] = public_key;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
