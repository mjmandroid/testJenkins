import Flutter
import UIKit

public class FlutterClientOssPlugin: NSObject, FlutterPlugin {
    private var client:FOssClient?
    private var channel:FlutterMethodChannel!
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_client_oss", binaryMessenger: registrar.messenger())
    let instance = FlutterClientOssPlugin()
      instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initSdk":
        client = FOssClient(channel: channel)
        print(call.method,call.arguments)
        client?.initSdk(call, result: result)
        break
    case "asyncResumableUpload":
        print(call.method,call.arguments)
        client?.asyncResumableUpload(call,result: result)
        break
    case "asyncResumableDownload":
        print(call.method,call.arguments)
        client?.asyncResumableDownload(call,result: result)
        break
    case "setSpeedLimit":
        print(call.method,call.arguments)
        client?.speedLimit = call.arguments as! Int?
        result(nil)
        break
    case "checkFile":
        client?.checkFile(call, result: result)
        break
    case "getSignUrl":
        client?.getSignUrl(call, result: result)
        break
    case "cancelTask":
        client?.cancelTask(taskId: call.arguments as! String)
        result(nil)
        break
    case "cancelAllTask":
        client?.cancelAllTask()
        result(nil)
        break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
