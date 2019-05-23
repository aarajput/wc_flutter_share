import Flutter
import UIKit

public class SwiftWcFlutterSharePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wc_flutter_share", binaryMessenger: registrar.messenger())
        let instance = SwiftWcFlutterSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "text":
            onText(args: call.arguments)
        case "file":
            onFile(args: call.arguments)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onText(args: Any?) {
        let argsMap = args as! NSDictionary
        let text:String = argsMap.value(forKey: "text") as! String
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
    public func onFile(args: Any?) {
        let argsMap = args as! NSDictionary
        let fileName:String = argsMap.value(forKey: "fileName") as! String
        let textToShare:String? = argsMap.value(forKey: "textToShare") as? String
        // load the file
        let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
        let contentUri = NSURL(fileURLWithPath: docsPath).appendingPathComponent(fileName)
        var contentToShare:[Any] = [];
        contentToShare.append(contentUri!);
        if (textToShare != nil) {
            contentToShare.append(textToShare!)
        }
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: contentToShare, applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
}
