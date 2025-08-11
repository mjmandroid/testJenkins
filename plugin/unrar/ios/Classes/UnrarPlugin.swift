import Flutter
import UIKit
import UnrarKit
// 新增支持zip解压
import UnzipKit

public class UnrarPlugin: NSObject, FlutterPlugin {
    

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "unrar_file", binaryMessenger: registrar.messenger())
        let instance = UnrarPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "extractFile":

                guard let arguments = call.arguments as? [String: Any] else {
                    result(["status": false, "message": "Invalid arguments"])
                    return
                }

                let filePath = arguments["file_path"] as? String ?? ""
                let destinationPath = arguments["destination_path"] as? String ?? ""
                let password = arguments["password"] as? String ?? ""

                if filePath.isEmpty || destinationPath.isEmpty {
                    result(["status": false, "message": "File path or destination path is empty"])
                    return
                }

                // 在后台线程执行解压操作，防止APP卡死
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        var fileList: [String] = []
                        let fileExtension = (filePath as NSString).pathExtension.lowercased()

                        if fileExtension == "rar" {
                            let archive = try URKArchive(path: filePath)
                            if !password.isEmpty {
                                archive.password = password
                            }
                            // 执行解压操作（覆盖已有文件）
                            try archive.extractFiles(to: destinationPath, overwrite: true)
                            fileList = try FileManager.default.contentsOfDirectory(atPath: destinationPath)
                        } else if fileExtension == "zip" {
                            let archive = try UZKArchive(path: filePath)
                            if !password.isEmpty {
                                archive.password = password
                            }
                            try archive.extractFiles(to: destinationPath, overwrite: true)
                            // 获取解压后的文件列表
                            fileList = try FileManager.default.contentsOfDirectory(atPath: destinationPath)
                        } else {
                            DispatchQueue.main.async {
                                result(["status": false, "message": "Unsupported file type: \(fileExtension)"])
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            result(["status": true, "message": "success", "files": fileList])
                        }
                    } catch {

                        DispatchQueue.main.async {
                            result(["status": false, "message": error.localizedDescription])
                        }
                    }
                }
                
            case "listFileInfo":
                // 解析 Flutter 传递的参数
                guard let arguments = call.arguments as? [String: Any] else {
                    result(["status": false, "message": "Invalid arguments"])
                    return
                }

                let filePath = arguments["file_path"] as? String ?? ""
                // destinationPath is not used for listFileInfo, but password might be.
                let password = arguments["password"] as? String ?? ""

                if filePath.isEmpty {
                    result(["status": false, "message": "File path is empty"])
                    return
                }

                // 在后台线程执行解压操作
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        var fileInfoList: [[String: Any]] = []
                        let fileExtension = (filePath as NSString).pathExtension.lowercased()

                        if fileExtension == "rar" {
                            let archive = try URKArchive(path: filePath)
                            if !password.isEmpty {
                                archive.password = password
                            }
                            let rarFileInfos = try archive.listFileInfo()
                            for info in rarFileInfos {
                                fileInfoList.append([
                                    "filename": info.filename ?? "",
                                    "isDirectory": info.isDirectory,
                                    "uncompressedSize": info.uncompressedSize
                                ])
                            }
                        } else if fileExtension == "zip" {
                            let archive = try UZKArchive(path: filePath)
                            if !password.isEmpty {
                                archive.password = password
                            }
                            let zipFileInfos = try archive.listFileInfo() // UZKArchive also has listFileInfo
                            for info in zipFileInfos {
                                fileInfoList.append([
                                    "filename": info.filename ?? "",
                                    "isDirectory": info.isDirectory,
                                    "uncompressedSize": info.uncompressedSize
                                ])
                            }
                        } else {
                            DispatchQueue.main.async {
                                result(["status": false, "message": "Unsupported file type for listing: \(fileExtension)"])
                            }
                            return
                        }

                        DispatchQueue.main.async {
                            result(["status": true, "message": "success", "files": fileInfoList])
                        }
                    } catch {
                        DispatchQueue.main.async {
                            result(["status": false, "message": error.localizedDescription])
                        }
                    }
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
    }
}
