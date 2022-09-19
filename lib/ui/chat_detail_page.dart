import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat.dart';
import 'package:flutter_chat/model/message.dart';
import 'package:flutter_chat/provider/user_provider.dart';
import 'package:flutter_chat/ui/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatTextFieldInputProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: "");
});

final chatProvider = StreamProvider.family<Chat, String>((ref, groupId) {
  final snapshots =
      FirebaseFirestore.instance.collection("chat").doc(groupId).snapshots();
  return snapshots.map(
    (snapshot) => Chat.fromDocument(snapshot.data()!),
  );
});

class ChatDetailPage extends ConsumerWidget {
  const ChatDetailPage({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider
    final inputFieldController = ref.watch(chatTextFieldInputProvider);
    final String myUserId = ref.read(userProvider);
    final AsyncValue<Chat> chatSnapshot = ref.watch(chatProvider(chat.groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(chat.groupName),
      ),
      body: Column(
        children: [
          Flexible(
            child: chatSnapshot.when(
              data: (data) => ListView.builder(
                itemCount: data.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatMessage(
                          content: data.messages[index]["content"],
                          imageUrl: data.imageUrl,
                          isMine: data.messages[index]["senderId"] == myUserId,
                        ),
                      ],
                    ),
                  );
                },
              ),
              error: (err, _) => const SnackBar(
                content: Text("データが取得できませんでした"),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: SizedBox(
              height: 36,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: inputFieldController,
                      decoration: InputDecoration(
                        hintText: 'メッセージを入力',
                        hintStyle: const TextStyle(
                          fontSize: 10.0,
                        ),
                        fillColor: Colors.green[100],
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        prefixIcon: const Icon(Icons.message),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("chat")
                          .doc(chat.groupId)
                          .update(
                        {
                          "messages": FieldValue.arrayUnion(
                            [
                              Message(
                                inputFieldController.text,
                                Timestamp.fromDate(DateTime.now()),
                                myUserId,
                              ).toMap(),
                            ],
                          )
                        },
                      );
                      // clear text
                      inputFieldController.clear();
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
