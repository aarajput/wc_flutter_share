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
        case "share":
            onShare(args: call.arguments)
            break;
        default:
            result(FlutterMethodNotImplemented)
        }
    }


    public func onShare(args: Any?) {
        let argsMap = args as! NSDictionary

        let text: String? = argsMap.value(forKey: "text") as? String
        let subject: String? = argsMap.value(forKey: "subject") as? String
        let fileName: String? = argsMap.value(forKey: "fileName") as? String
        let mimeType: String = argsMap.value(forKey: "mimeType") as! String

        var contentToShare: [Any] = []

        if (fileName != nil) {
            // load the file
            let docsPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            if let image = getAsImageContent(path: docsPath, fileName: fileName!, mimeType: mimeType) {
                contentToShare.append(image)
            } else {
                let contentUri = NSURL(fileURLWithPath: docsPath).appendingPathComponent(fileName!)
                contentToShare.append(contentUri!)
            }
        }

        if (text != nil) {
            contentToShare.append(text!)
        }

        // set up activity view controller
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: contentToShare, applicationActivities: nil)
        if (subject != nil) {
            contentToShare.append(subject!)
            activityViewController.setValue(subject!, forKey: "Subject")
        }

        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let popover = activityViewController.popoverPresentationController {
                popover.sourceView = controller.view
                let bounds = controller.view.bounds

                let originX: NSNumber = argsMap.value(forKey: "originX") as! NSNumber
                let originY: NSNumber = argsMap.value(forKey: "originY") as! NSNumber
                var originWidth: NSNumber = argsMap.value(forKey: "originWidth") as! NSNumber
                var originHeight: NSNumber = argsMap.value(forKey: "originHeight") as! NSNumber

                if (originWidth.intValue > (bounds.width - 96 as NSNumber).intValue) {
                    originWidth = NSNumber(value: Float((bounds.width - 96)))
                }
                if (originHeight.intValue > (bounds.height - 96 as NSNumber).intValue) {
                    originHeight = NSNumber(value: Float((bounds.height - 96)))
                }

                popover.sourceRect = CGRect(x: originX.doubleValue,
                        y: originY.doubleValue,
                        width: originWidth.doubleValue,
                        height: originHeight.doubleValue);
            }
        }

        controller.show(activityViewController, sender: self)
    }

    private func isImageMimeType(mimeType: String) -> Bool {
        if (mimeType == "image/png") {
            return true;
        }
        if (mimeType == "image/jpg") {
            return true;
        }
        if (mimeType == "image/jpeg") {
            return true;
        }
        return false;
    }

    private func getAsImageContent(path: String, fileName: String, mimeType: String) -> Data? {
        if (!isImageMimeType(mimeType: mimeType)) {
            return nil
        }

        let contentUri = NSURL(fileURLWithPath: path).appendingPathComponent(fileName)

        if (contentUri?.path != nil) {
            if let image = UIImage(contentsOfFile: contentUri!.path) {

                if (mimeType == "image/png") {
                    if let imagePNG = image.pngData() {
                        let imageData: Data = imagePNG
                        return imageData
                    }
                } else if (mimeType == "image/jpg" || mimeType == "image/jpeg") {
                    if let imageJPEG = image.jpegData(compressionQuality: 1) {
                        let imageData: Data = imageJPEG
                        return imageData
                    }
                }
            }
        }
        return nil
    }
}
