import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String groupId;
  final String groupName;
  final Timestamp createdAt;
  final String imageUrl;
  final List<dynamic> members;
  final List<dynamic> messages;

  Chat(this.groupId, this.groupName, this.createdAt, this.imageUrl,
      this.members, this.messages);

  factory Chat.fromDocument(Map<String, dynamic> document) {
    return Chat(
      document["groupId"],
      document["groupName"],
      document["createdAt"],
      document["imageUrl"],
      document["members"],
      document["messages"],
    );
  }
}
