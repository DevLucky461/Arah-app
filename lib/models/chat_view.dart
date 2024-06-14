class ChatView {
  int id;
  String message;
  String message_type;
  String message_datetime;
  String UUID;
  String name;
  String image;
  String phone;
  String created_at;
  bool showImg = false;
  bool isFound = false;
  bool isSelected = false;

  ChatView({
    this.id,
    this.message,
    this.message_type,
    this.message_datetime,
    this.UUID,
    this.name,
    this.image,
    this.phone,
    this.created_at,
    this.showImg,
    this.isFound,
    this.isSelected,
  });

  factory ChatView.fromJson(Map<String, dynamic> json) {
    return ChatView(
      id: json['id'],
      message: json['message'],
      message_type: json['message_type'],
      message_datetime: json['message_datetime'],
      UUID: json['UUID'],
      name: json['sender_name'] != null ? json['sender_name'] : "",
      image: json['image'] != null ? json['image'] : "",
      phone: json['phone'] != null ? json['phone'] : "",
      created_at: json['created_at'],
      showImg: false,
      isFound: false,
      isSelected: false,
    );
  }
}
