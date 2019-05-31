import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class WcFlutterShare {
  static const MethodChannel _channel = const MethodChannel('wc_flutter_share');

  /// Sends a text and file to other apps.
  static Future<void> share(
      {@required String sharePopupTitle,
      String text,
      String subject,
      String fileName,
      @required String mimeType,
      List<int> bytesOfFile}) async {
    Map argsMap = <String, String>{
      'sharePopupTitle': sharePopupTitle,
      'text': text,
      'subject': subject,
      'fileName': fileName,
      'mimeType': mimeType,
    };

    if (mimeType == null) {
      throw ArgumentError('mimeType is required');
    }
    if (sharePopupTitle == null) {
      throw ArgumentError(
          'sharePopupTitle is required. This is actualy required for android.');
    }

    if (fileName != null && bytesOfFile != null) {
      final tempDir = await pathProvider.getTemporaryDirectory();
      final file = await new File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(bytesOfFile);
    } else if (fileName != null && bytesOfFile == null) {
      throw ArgumentError('bytesOfFile is required if fileName is passed');
    } else if (bytesOfFile != null && fileName == null) {
      throw ArgumentError('fileName is required if bytesOfFile is passed');
    }

    _channel.invokeMethod('share', argsMap);
  }
}
