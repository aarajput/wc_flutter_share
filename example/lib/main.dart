import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('How to: wc_flutter_share'),
          textTheme: TextTheme(button: TextStyle(color: Colors.black)),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            FlatButton(onPressed: _shareText, child: Text('Share text')),
            SizedBox(
              height: 10,
            ),
            FlatButton(onPressed: _shareImage, child: Text('Share file only')),
            SizedBox(
              height: 10,
            ),
            FlatButton(onPressed: _shareImageAndText, child: Text('Share file and text')),
          ],
        ),
      ),
    );
  }

  void _shareText() async {
    try {
      WcFlutterShare.text(
          'This is share title', 'This is share text', 'text/plain');
    } catch (e) {
      print(e);
    }
  }

  void _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/wisecrab.png');
      await WcFlutterShare.file(
          'This is popuptitle',
          null,
          null,
          'share.png',
          'image/png',
          bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }

  void _shareImageAndText() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/wisecrab.png');
      await WcFlutterShare.file(
          'This is share title',
          'This is share text',
          'This is subject text',
          'share.png',
          'image/png',
          bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }
}
