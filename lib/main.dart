import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/provider/user_provider.dart';
import 'package:flutter_chat/ui/chat_list_page.dart';
import 'package:flutter_chat/ui/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: ChatApp(),
    ),
  );
}

class ChatApp extends ConsumerWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);

    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: user != null ? const ChatListPage() : const LoginPage(),
    );
  }
}
