import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WcFlutterSharePlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'wc_flutter_share', const StandardMethodCodec(), registrar.messenger);
    final WcFlutterSharePlugin instance = WcFlutterSharePlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'share':
//        final String url = call.arguments['url'];
        return await _share(call.arguments);
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The WcFlutterSharePlugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  Future<bool> _share(Map argsMap) async {
    js.JsObject nav = js.JsObject.fromBrowserObject(js.context["navigator"]);
    if (nav.hasProperty("share")) {
      try {
        if(argsMap.containsKey("file")){
          if (nav.hasProperty("canShare") != null &&
              nav.callMethod("canShare", [
                js.JsObject.jsify({"files": argsMap["file"]})
              ])) {
            await html.window.navigator.share({
              "title": argsMap["title"],
              "text": argsMap["text"],
              "files": argsMap["file"],
            });
            return true;
          }
        }

        await html.window.navigator.share({
          "title": argsMap["title"],
          "text": (argsMap["alternateText"]?? "") + argsMap["text"],
        });
        return true;
      } catch (err) {
        print(err);
        return false;
      }
    }

    return false;
  }
}
