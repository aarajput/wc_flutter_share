import 'dart:js';

import 'package:wc_flutter_share/write_to_file_interface.dart';

class WriteToFileWeb implements WriteToFile{
  @override
  Future<Map> write({List<int> bytesOfFile, String fileName, argsMap}) async{
    JsArray jsArray = JsArray.from(bytesOfFile);
    argsMap["file"] = [jsArray];
    return argsMap;
  }



}

WriteToFile getWriteToFile() => WriteToFileWeb();