import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:blowfish_native/blowfish_native.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _encryptedPassword = '';

  @override
  void initState() {
    super.initState();
    initPasswordEncryption();
  }

  Future<void> initPasswordEncryption() async {
    String encryptedPassword;
    try {
      encryptedPassword = await BlowfishNative.encrypt('key', 'password');
    } on PlatformException {
      encryptedPassword = 'Failed to encrypt password.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _encryptedPassword = encryptedPassword;
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
          child: new Text('Encrypted password: $_encryptedPassword\n'),
        ),
      ),
    );
  }
}
