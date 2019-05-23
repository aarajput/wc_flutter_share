import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class WcFlutterShare {
  static const MethodChannel _channel = const MethodChannel('wc_flutter_share');

  /// Sends a text to other apps.
  static void text(String title, String text, String mimeType) {
    Map argsMap = <String, String>{
      'title': '$title',
      'text': '$text',
      'mimeType': '$mimeType'
    };
    _channel.invokeMethod('text', argsMap);
  }

  /// Sends a file to other apps.
  static Future<void> file(
      String sharePopupTitle,
      String textToShare,
      String subjectToShare,
      String fileName,
      String mimeTypeOfFile,
      List<int> bytesOfFile) async {
    Map argsMap = <String, String>{
      'sharePopupTitle': '$sharePopupTitle',
      'textToShare': textToShare,
      'subjectToShare': subjectToShare,
      'fileName': '$fileName',
      'mimeTypeOfFile': '$mimeTypeOfFile',
    };

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(bytesOfFile);

    _channel.invokeMethod('file', argsMap);
  }
}
