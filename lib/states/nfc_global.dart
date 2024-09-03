import 'package:nfc_manager/nfc_manager.dart';

class NfcGlobal {
  static void Function(NfcTag tag)? newTag;

  static void startSession() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        newTag?.call(tag);
      },
    );
  }
}
