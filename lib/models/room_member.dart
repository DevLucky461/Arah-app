class RoomMember {
  int id;
  String user_type;
  String name;
  String image;
  String date_join;
  bool isMuted;

  RoomMember({
    this.id,
    this.user_type,
    this.name,
    this.image,
    this.date_join,
    this.isMuted,
  });

  factory RoomMember.fromJson(Map<String, dynamic> json) {
    return RoomMember(
      id: json['id'],
      user_type: json['user_type'],
      name: json['name'],
      image: json['image'],
      date_join: json['date_join'],
      isMuted: json['rooms_notification'] == "on" ? false : true,
    );
  }
}
