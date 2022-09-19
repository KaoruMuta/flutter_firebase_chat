import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final Timestamp createdAt;
  final String senderId;

  Message(this.content, this.createdAt, this.senderId);

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "createdAt": createdAt,
      "senderId": senderId,
    };
  }
}
