import 'package:badge_hack/constants.dart';
import 'package:badge_hack/global_vars.dart';
import 'package:badge_hack/nfc_helper.dart';
import 'package:badge_hack/states/nfc_global.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ScanNfcState extends StatefulWidget {
  const ScanNfcState({super.key});

  @override
  State<ScanNfcState> createState() => _ScanNfcStateState();
}

class _ScanNfcStateState extends State<ScanNfcState> {
  NfcTag? _scannedTag;
  int scannedScore = 0;

  @override
  void initState() {
    // Start Session
    NfcGlobal.newTag = (tag) => setState(() => _scannedTag = tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Falling Blob')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildNfcWidgets(),
          ),
        ),
      ),
      floatingActionButton: _scannedTag != null
          ? FloatingActionButton(
              onPressed: () async {
                GlobalVars.regenerateRandomFromNfcHash(_scannedTag!.handle);
                await Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: <String, int>{
                    Constants.nfcArgumentKey: scannedScore,
                  },
                );
                NfcGlobal.newTag = (tag) => setState(() => _scannedTag = tag);
                setState(() => _scannedTag = null);
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  List<Widget> _buildNfcWidgets() {
    if (_scannedTag == null) {
      return [
        const Text('Scan an NFC to play the game!'),
        const SizedBox(height: 30),
        const CircularProgressIndicator()
      ];
    }

    return [
      const Text('Ready to play!'),
      const SizedBox(height: 30),
      FutureBuilder(
          future: NfcHelper.getHighscore(_scannedTag),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Text("wuuuuuurst");
            } else {
              scannedScore = snapshot.data ?? 0;
              return Text(
                  "Current game has a highscore of ${snapshot.data ?? 0}");
            }
          })
    ];
  }
}
