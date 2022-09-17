import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: ListView.separated(
        itemCount: 32,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://kaorumuta.me/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fme.ca58372c.png&w=828&q=100"),
                  ),
                  const SizedBox(width: 12.0),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Kaoru Muta",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "おけ！おけ！おけ！おけ！おけ！おけ！おけ！おけ！おけ！おけ！おけ！おけ！おけ！",
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatDetailPage()),
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 0.5);
        },
      ),
    );
  }
}
