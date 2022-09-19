import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/chat_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final emailProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final passwordProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

bool _isValid(String name, String email, String password) {
  return name.length >= 5 && email.length >= 5 && password.length >= 5;
}

class SignupPage extends ConsumerWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameInputFieldController = ref.watch(nameProvider);
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Chat Appへようこそ！",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: nameInputFieldController,
                decoration: const InputDecoration(
                  label: Text(
                    "名前を入力",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              TextFormField(
                controller: emailInputFieldController,
                decoration: const InputDecoration(
                  label: Text(
                    "メールアドレスを入力",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
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
              ElevatedButton(
                onPressed: () async {
                  if (_isValid(
                    nameInputFieldController.text,
                    emailInputFieldController.text,
                    passwordInputFieldController.text,
                  )) {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: emailInputFieldController.text,
                          password: passwordInputFieldController.text,
                        )
                        .catchError(
                          (err) => print(err.message),
                        )
                        .then(
                          (authResult) => {
                            authResult.user?.updateDisplayName(
                              nameInputFieldController.text,
                            )
                          },
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
                  "新規登録",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
