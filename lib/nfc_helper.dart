import 'dart:convert';

import 'package:badge_hack/constants.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcHelper {
  static Future<int> getHighscore(NfcTag? tag) async {
    await Future.delayed(Duration(microseconds: 1));
    final x = Ndef.from(tag!);

    final raw = utf8.decode(x!.cachedMessage!.records.first.payload);
    final score = int.tryParse(raw ?? "0");
    return score ?? 0;
  }
}
