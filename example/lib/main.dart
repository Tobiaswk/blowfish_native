import 'package:flutter/material.dart';
import 'dart:async';

import 'package:blowfish_native/blowfish_native.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _encryptedPassword = 'Waiting for encryption';

  @override
  void initState() {
    super.initState();
    encryptPassword();
  }

  Future<void> encryptPassword() async {
    String encryptedPassword;
    encryptedPassword = await BlowfishNative.encrypt('key', 'Hello World!');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _encryptedPassword
   = encryptedPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Running on: ${_encryptedPassword}\n'),
        ),
      ),
    );
  }
}
