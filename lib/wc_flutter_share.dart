import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class WcFlutterShare {
  static const MethodChannel _channel = const MethodChannel('wc_flutter_share');

  /// Share a text, subject and file with other apps.
  static Future<void> share({
    required String sharePopupTitle,
    required String mimeType,
    String? text,
    String? subject,
    String? fileName,
    List<int>? bytesOfFile,
    IPadConfig? iPadConfig,
  }) async {
    if (fileName != null && bytesOfFile == null) {
      throw ArgumentError('bytesOfFile is required if fileName is passed');
    } else if (bytesOfFile != null && fileName == null) {
      throw ArgumentError('fileName is required if bytesOfFile is passed');
    }

    Map argsMap = <String, dynamic>{
      'sharePopupTitle': sharePopupTitle,
      'text': text,
      'subject': subject,
      'fileName': fileName,
      'mimeType': mimeType.toLowerCase(),
      'originX': iPadConfig?.originX ?? 0,
      'originY': iPadConfig?.originY ?? 0,
      'originWidth': iPadConfig?.originWidth ?? 0,
      'originHeight': iPadConfig?.originHeight ?? 0,
    };

    if (fileName != null && bytesOfFile != null) {
      final tempDir = await pathProvider.getTemporaryDirectory();
      final file = await new File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(bytesOfFile);
    }
    _channel.invokeMethod('share', argsMap);
  }
}

class IPadConfig {
  final int originX;
  final int originY;
  final int originWidth;
  final int originHeight;

  IPadConfig({
    required this.originX,
    required this.originY,
    required this.originWidth,
    required this.originHeight,
  });
}
