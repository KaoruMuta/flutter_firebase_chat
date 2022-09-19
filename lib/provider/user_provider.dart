import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider.autoDispose((ref) {
  // TODO: fetch user id from firebase auth
  return "hogehoge";
});
