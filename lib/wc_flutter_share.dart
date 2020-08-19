import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wc_flutter_share/write_to_file_interface.dart';

class WcFlutterShare {
  static const MethodChannel _channel = const MethodChannel('wc_flutter_share');

  /// Share a text, subject and file with other apps.
  static Future<bool> share({
    @required String sharePopupTitle,
    String text,
    String subject,
    String fileName,
    @required String mimeType,
    List<int> bytesOfFile,
    IPadConfig iPadConfig,
    String alternateText
  }) async {
    assert(sharePopupTitle != null);
    assert(mimeType != null);

    if (fileName != null && bytesOfFile == null) {
      throw ArgumentError('ytesOfFile is required if fileName is passed');
    } else if (bytesOfFile != null && fileName == null) {
      throw ArgumentError('fileName is required if bytesOfFile is passed');
    }

    Map argsMap = <String, dynamic>{
      'sharePopupTitle': sharePopupTitle,
      'text': text,
      'subject': subject,
      'fileName': fileName,
      'mimeType': mimeType,
      'originX': iPadConfig?.originX ?? 0,
      'originY': iPadConfig?.originY ?? 0,
      'originWidth': iPadConfig?.originWidth ?? 0,
      'originHeight': iPadConfig?.originHeight ?? 0,
      'alternateText': alternateText ?? ""
    };

    if (fileName != null && bytesOfFile != null) {
      WriteToFile writeToFile = WriteToFile();
      argsMap = await writeToFile.write(
          bytesOfFile: bytesOfFile,
          argsMap: argsMap,
          fileName: fileName
      );
    }
   return (await _channel.invokeMethod('share', argsMap))?? true;
  }
}

class IPadConfig {
  final int originX;
  final int originY;
  final int originWidth;
  final int originHeight;

  IPadConfig({
    this.originX,
    this.originY,
    this.originWidth,
    this.originHeight,
  });
}
