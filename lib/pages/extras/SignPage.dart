import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:path_provider/path_provider.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  SignatureView _signatureView = new SignatureView();

  Future<File> writeToFile(Uint8List data, String path) {
    // final buffer = data.buffer;
    return new File(path).writeAsBytes(data);
  }

  saveSign() async {
    Directory temp = await getApplicationDocumentsDirectory();
    // File sign = await writeToFile(
    //   await _signatureView.exportBytes(),
    //   temp.path + "/sign.png",
    // );
    Directory signatures = new Directory(temp.path + "/signatires");

    if (signatures.existsSync()) {
      signatures.listSync().forEach((element) {
        element.deleteSync();
      });
    }

    if (!signatures.existsSync()) {
      signatures.createSync();
    }
    File sign = new File(signatures.path +
        "/sign" +
        Random.secure().nextInt(100).toString() +
        ".png");

    await sign
        .writeAsBytes(List.from(await _signatureView.exportBytes() ?? []));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text("Signature"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.clear),
          //   onPressed: () {
          //     _signatureView.clear();
          //   },
          // ),
          TextButton(
            child: Text("Clear"),
            onPressed: () {
              _signatureView.clear();
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              saveSign();
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     Directory temp = await getApplicationDocumentsDirectory();
      //     // File sign = await writeToFile(
      //     //   await _signatureView.exportBytes(),
      //     //   temp.path + "/sign.png",
      //     // );
      //     Directory signatures = new Directory(temp.path + "/signatires");

      //     if (signatures.existsSync()) {
      //       signatures.listSync().forEach((element) {
      //         element.deleteSync();
      //       });
      //     }

      //     if (!signatures.existsSync()) {
      //       signatures.createSync();
      //     }
      //     File sign = new File(signatures.path +
      //         "/sign" +
      //         Random.secure().nextInt(100).toString() +
      //         ".png");

      //     await sign.writeAsBytes(await _signatureView.exportBytes());

      //     SystemChrome.setPreferredOrientations(
      //         [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      //     Navigator.pop(context);
      //   },
      // ),
      body: _signatureView,
    );
  }
}
