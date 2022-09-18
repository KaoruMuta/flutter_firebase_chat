import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat.dart';
import 'package:flutter_chat/ui/chat_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = StreamProvider.autoDispose<List<Chat>>((ref) {
  final snapshots = FirebaseFirestore.instance.collection("chat").snapshots();
  return snapshots.map(
    (snapshot) => snapshot.docs
        .map(
          (doc) => Chat.fromDocument(doc.data()),
        )
        .toList(),
  );
});

class ChatListPage extends ConsumerWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Chat>> chatList = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: chatList.when(
        data: (data) => ListView.separated(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        data[index].imageUrl,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].groupName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data[index].messages.last["content"],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
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
                  MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                      chat: data[index],
                    ),
                  ),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 0.5);
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, _) => Text(err.toString()),
      ),
    );
  }
}
