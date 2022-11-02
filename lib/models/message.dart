class Message {
  String? id;
  String? message;
  String? senderId;
  String? receiverId;
  String? groupId;
  String? createdAt;

  Message({
    required this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.groupId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'senderId': senderId,
        'receiverId': receiverId,
        'groupId': groupId,
        'createdAt': createdAt,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        message: json['message'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        groupId: json['groupId'],
        createdAt: json['createdAt'],
      );
}
