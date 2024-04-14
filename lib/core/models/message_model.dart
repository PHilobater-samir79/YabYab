class MessageModel {
  String message, messageId, senderId, receiverId, createdAt, type, readAt;
  MessageModel(
      {required this.message,
      required this.messageId,
      required this.senderId,
      required this.receiverId,
      required this.createdAt,
      required this.type,
      required this.readAt});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        message: json['message'],
        messageId: json['messageId'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        createdAt: json['createdAt'],
        type: json['type'],
        readAt: json['readAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'type': type,
      'readAt': readAt
    };
  }
}
