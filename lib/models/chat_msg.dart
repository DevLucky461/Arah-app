class ChatMsg {
  int id;
  int user_id;
  String message;
  String UUID;
  String name;
  String image;
  String phone;
  String last_received;
  String room_created;
  String last_message;
  String last_message_type;
  int last_msg_sender_id;
  String last_msg_sender_name;
  String type;
  int unread;
  bool selected = false;

  ChatMsg(
      {this.id,
      this.user_id,
      this.message,
      this.UUID,
      this.name,
      this.image,
      this.phone,
      this.last_received,
      this.room_created,
      this.last_message,
      this.last_message_type,
      this.last_msg_sender_id,
      this.last_msg_sender_name,
      this.type,
      this.unread,
      this.selected});

  factory ChatMsg.fromJson(Map<String, dynamic> json) {
    return ChatMsg(
      id: json['id'],
      user_id: json['user_id'],
      message: json['message'],
      UUID: json['UUID'],
      name: json['group_name'],
      image: json['group_image'],
      phone: json['phone'],
      last_received: json['last_received'] == null ? '' : json['last_received'],
      room_created: json['room_created'] == null ? '' : json['room_created'],
      last_message: json['last_message'] == null ? '' : json['last_message'],
      last_message_type: json['last_message_type'] == null ? '' : json['last_message_type'],
      last_msg_sender_id: json['last_msg_sender_id'] == null ? -1 : json['last_msg_sender_id'],
      last_msg_sender_name:
          json['last_msg_sender_name'] == null ? '' : json['last_msg_sender_name'],
      type: json['group_type'],
      unread: json['unread'] == null ? 0 : json['unread'],
      selected: false,
    );
  }
}
