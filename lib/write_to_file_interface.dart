import 'write_to_file_stub.dart'

// ignore: uri_does_not_exist
if (dart.library.io) 'package:wc_flutter_share/write_to_file.dart'
// ignore: uri_does_not_exist
if (dart.library.html) 'package:wc_flutter_share/write_to_file_web.dart';

abstract class WriteToFile {

  // some generic methods to be exposed.

  Future<Map> write({List<int> bytesOfFile, String fileName,Map argsMap}) async{
    return argsMap;
  }

  /// factory constructor to return the correct implementation.
  factory WriteToFile() => getWriteToFile();
}