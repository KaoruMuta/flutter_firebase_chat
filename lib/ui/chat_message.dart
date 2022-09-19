import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key, required this.content, this.imageUrl, this.isMine = false})
      : super(key: key);

  final bool isMine;
  final String? imageUrl;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: isMine
          ? [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 16),
                child: Text(
                  content,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 200, 230, 201),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ]
          : [
              CircleAvatar(
                maxRadius: 12.0,
                backgroundImage: NetworkImage(
                  imageUrl ?? "",
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 16),
                child: Text(
                  content,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 200, 230, 201),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ],
    );
  }
}
