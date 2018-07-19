import 'dart:async';

import 'package:flutter/services.dart';

class BlowfishNative {
  static const MethodChannel _channel =
      const MethodChannel('blowfish_native');

  static Future<String> encrypt(String key, String password) async {
    final String version = await _channel.invokeMethod('encrypt', [key, password]);
    return version;
  }
}
