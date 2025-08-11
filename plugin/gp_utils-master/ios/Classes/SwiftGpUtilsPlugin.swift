import Flutter
import UIKit
import AdSupport
import KeychainAccess
import AppTrackingTransparency

public class SwiftGpUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gp_utils", binaryMessenger: registrar.messenger())
    let instance = SwiftGpUtilsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "version":
        result(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")
        break
    case "versionCode":
        result(Bundle.main.infoDictionary?["CFBundleVersion"] ?? "")
        break
    case "appName":
        result(Bundle.main.infoDictionary?["CFBundleDisplayName"] ?? "")
        break
    case "idfa":
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                if (status == .authorized){
                    result(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                }else{
                    result("")
                }
            })
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                result(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
            }else{
                result("")
            }
        }
        break
    case "bundleInfo":
        let key = (call.arguments as? [String:Any?])?["key"]
        if (key == nil){
            result("")
        }else{
            result(Bundle.main.infoDictionary?[key as! String])
        }
        break
    case "uniqueDeviceId":
        result(getUuid())
        break
    case "deviceType":
        result(UIDevice.current.model);
        break
    case "openAppSetting":
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        break
    default:
        result("")
        break
    }
  }
    
    private func getUuid()->String{
        let keychain = Keychain(service: "com.kawa.xingda.uuid")
        let uuid = keychain["uuid"] ?? ""
        if uuid.isEmpty {
            let temp = UIDevice.current.identifierForVendor?.uuidString ?? ""
            keychain["uuid"] = temp
            return temp
        }
        return uuid
    }
}
