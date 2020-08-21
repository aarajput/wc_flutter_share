import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:wc_flutter_share/write_to_file_interface.dart';

class WriteToFileMobile implements WriteToFile{
  @override
  Future<Map> write({List<int> bytesOfFile, String fileName, argsMap}) async{
    final tempDir = await pathProvider.getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(bytesOfFile);
    return argsMap;
  }



}

WriteToFile getWriteToFile() => WriteToFileMobile();






