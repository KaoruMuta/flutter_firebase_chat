import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/chat_list_page.dart';
import 'package:flutter_chat/ui/signup_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final passwordProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

bool _isValid(String email, String password) {
  return email.length >= 5 && password.length >= 5;
}

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailInputFieldController = ref.watch(emailProvider);
    final passwordInputFieldController = ref.watch(passwordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ユーザー情報入力",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailInputFieldController,
                decoration: const InputDecoration(
                  label: Text(
                    "メールアドレスを入力",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              TextFormField(
                controller: passwordInputFieldController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'パスワードを入力',
                  hintStyle: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 128,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_isValid(
                    emailInputFieldController.text,
                    passwordInputFieldController.text,
                  )) {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: emailInputFieldController.text,
                          password: passwordInputFieldController.text,
                        )
                        .catchError(
                          (err) => print(err.message),
                        );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatListPage(),
                      ),
                      (_) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("入力に不備があります。再入力して下さい"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text(
                  "ログイン",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
                child: const Text(
                  "新規登録はこちら",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
