import UIKit
import Flutter
import GoogleMaps
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDyEVBI6DMAPZH5y4x6sxX1-DNOzXRMbcs")

/*
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "flutter_absolute_path",
                                                  binaryMessenger: controller.binaryMessenger)

                  batteryChannel.setMethodCallHandler({
                  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in

                  // Note: this method is invoked on the UI thread.
                  guard call.method == "getAbsolutePath" else {
                   result(FlutterMethodNotImplemented)
                   return
                  }
                self?.handle(result: result)
              })
 */
  if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)



  }





    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "getAbsolutePath"){
            guard let uri = (call.arguments as? Dictionary<String, String>)?["uri"] else {
                result(FlutterError(code: "assertion_error", message: "uri is required.", details: nil))
                return
            }
            if (uri.starts(with: "file://") || uri.starts(with: "/var/mobile/Media") || uri.starts(with: "/private/var/mobile")) {
                result( uri.replacingOccurrences(of: "file://", with: ""))
                return
            }
            let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [uri], options: .none).firstObject
            if(phAsset == nil) {
                result(nil)
                return
            }
            let editingOptions = PHContentEditingInputRequestOptions()
            editingOptions.isNetworkAccessAllowed = true
            phAsset!.requestContentEditingInput(with: editingOptions) { (input, _) in
                let url = input?.fullSizeImageURL?.absoluteString.replacingOccurrences(of: "file://", with: "")
                result(url)
            }
        }
    }
}
