//
//  FOssClient.swift
//  flutter_client_oss
//
//  Created by lv on 2024/10/12.
//

import UIKit
import Flutter
import AliyunOSSiOS

class FOssClient: NSObject {
    var speedLimit:Int?
    private var client: OSSClient!
    private lazy var taskMap = [String:FOssClientTask]()
    private let channel:FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func initSdk(_ call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments as? [String: Any?] else {
            result(0)
            return
        }
        guard let sts = args["sts"] as? [String: Any?] else {
            result(0)
            return
        }
        guard let accessKeyId = sts["accessKeyId"] as? String else {
            result(0)
            return
        }
        guard let accessKeySecret = sts["accessKeySecret"] as? String else {
            result(0)
            return
        }
        guard let securityToken = sts["securityToken"] as? String else {
            result(0)
            return
        }
        guard let endPoint = args["endPoint"] as? String else {
            result(0)
            return
        }
        let provider = OSSStsTokenCredentialProvider.init(accessKeyId: accessKeyId, secretKeyId: accessKeySecret, securityToken: securityToken)
        client = OSSClient.init(endpoint: endPoint, credentialProvider: provider)
        print("=================initSdk")
        print(client)
        result(1)
    }
    
    // func asyncResumableUpload(_ call: FlutterMethodCall,result: @escaping FlutterResult){
    //     guard let args = call.arguments as? [String: Any?] else {
    //         result(0)
    //         return
    //     }
    //     guard let bucketName = args["bucketName"] as? String else {
    //         result(0)
    //         return
    //     }
    //     guard let ossFileName = args["ossFileName"] as? String else {
    //         result(0)
    //         return
    //     }
    //     guard let filePath = args["filePath"] as? String else {
    //         result(0)
    //         return
    //     }
    //     guard let recordDir = args["recordDir"] as? String else {
    //         result(0)
    //         return
    //     }
    //     let managerTask = FOssClientTask()
    //     let taskId = "\(managerTask.hash)"
    //     let upload = OSSResumableUploadRequest()
    //     upload.bucketName = bucketName
    //     upload.objectKey = ossFileName
    //     var isDir: ObjCBool = false
    //     if !FileManager.default.fileExists(atPath: recordDir, isDirectory: &isDir) {
    //         try? FileManager.default.createDirectory(atPath: recordDir, withIntermediateDirectories: true)
    //     }
    //     upload.recordDirectoryPath = recordDir
    //     upload.deleteUploadIdOnCancelling = false
    //     upload.uploadingFileURL = NSURL.fileURL(withPath: filePath)
    //     upload.uploadProgress = {[weak self] send,totalBytes,totalBytesExpected in
    //         if (totalBytesExpected == 0){
    //             return
    //         }
    //         DispatchQueue.main.async {
    //             self?.channel.invokeMethod("uploadProgress", arguments: [
    //                 "current": totalBytes,
    //                 "total": totalBytesExpected,
    //                 "taskId": taskId
    //             ])
    //         }
    //     }
    //     let resumeTask = client.resumableUpload(upload)
    //     resumeTask.continue({[weak self] task in
    //         if let error = task.error as? NSError {
    //             if (error.code == 5){
    //                 //用户取消
    //                 DispatchQueue.main.async {
    //                     self?.channel.invokeMethod("uploadResult", arguments: [
    //                         "success":0,
    //                         "taskId": taskId,
    //                         "cancel":1,
    //                         "message": error.localizedDescription
    //                     ])
    //                 }
    //             }else{
    //                 DispatchQueue.main.async {
    //                     self?.channel.invokeMethod("uploadResult", arguments: [
    //                         "success":0,
    //                         "taskId": taskId,
    //                         "cancel":0,
    //                         "message": error.localizedDescription
    //                     ])
    //                 }
    //             }
    //         }else{
    //             DispatchQueue.main.async {
    //                 self?.channel.invokeMethod("uploadResult", arguments: [
    //                     "success":1,
    //                     "taskId": taskId
    //                 ])
    //             }
    //         }
    //         return nil
    //     })
    //     managerTask.task = resumeTask
    //     managerTask.request = upload
    //     taskMap[taskId] = managerTask
    //     result(taskId)
    // }

    func asyncResumableUpload(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // 参数验证部分保持不变
        guard let args = call.arguments as? [String: Any?],
            let bucketName = args["bucketName"] as? String,
            let ossFileName = args["ossFileName"] as? String,
            let filePath = args["filePath"] as? String,
            let recordDir = args["recordDir"] as? String else {
            result(0)
            return
        }
        
        // 使用更高优先级的后台队列处理上传任务
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // 文件检查部分保持不变
            guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath),
                let fileSize = fileAttributes[.size] as? UInt64 else {
                DispatchQueue.main.async {
                    result(0)
                }
                return
            }
            
            let managerTask = FOssClientTask()
            let taskId = "\(managerTask.hash)"
            let upload = OSSResumableUploadRequest()
            
            // 基本配置保持不变
            upload.bucketName = bucketName
            upload.objectKey = ossFileName
            upload.recordDirectoryPath = recordDir
            upload.deleteUploadIdOnCancelling = false
            upload.uploadingFileURL = NSURL.fileURL(withPath: filePath)
            
            // 优化分片大小策略
            if fileSize > 500 * 1024 * 1024 { // 大于500MB
                upload.partSize = 2 * 1024 * 1024  // 2MB分片
            } else if fileSize > 100 * 1024 * 1024 { // 大于100MB
                upload.partSize = 1024 * 1024  // 1MB分片
            } else if fileSize > 10 * 1024 * 1024 { // 大于10MB
                upload.partSize = 512 * 1024  // 512KB分片
            } else {
                upload.partSize = 256 * 1024  // 256KB分片
            }
            
            // 进度回调优化
            var lastProgressTime = Date()
            var lastProgress: Float = 0
            let progressQueue = DispatchQueue(label: "com.oss.progress")
            
            // 根据文件大小动态调整进度回调策略
            let minProgressInterval: TimeInterval
            let minProgressChange: Float
            
            if fileSize > 100 * 1024 * 1024 {
                minProgressInterval = 1.0     // 大文件每秒最多更新一次
                minProgressChange = 0.02      // 至少2%的变化
            } else if fileSize > 10 * 1024 * 1024 {
                minProgressInterval = 0.5     // 中等文件每0.5秒最多更新一次
                minProgressChange = 0.01      // 至少1%的变化
            } else {
                minProgressInterval = 0.2     // 小文件每0.2秒最多更新一次
                minProgressChange = 0.005     // 至少0.5%的变化
            }
            
            upload.uploadProgress = { [weak self] send, totalBytes, totalBytesExpected in
                guard let self = self,
                    totalBytesExpected > 0 else { return }
                
                let currentProgress = Float(totalBytes) / Float(totalBytesExpected)
                let now = Date()
                
                // 使用专门的队列处理进度逻辑
                progressQueue.async {
                    // 检查是否满足更新条件
                    if now.timeIntervalSince(lastProgressTime) >= minProgressInterval &&
                    abs(currentProgress - lastProgress) >= minProgressChange {
                        
                        lastProgressTime = now
                        lastProgress = currentProgress
                        
                        DispatchQueue.main.async {
                            self.channel.invokeMethod("uploadProgress", arguments: [
                                "current": totalBytes,
                                "total": totalBytesExpected,
                                "taskId": taskId
                            ])
                        }
                    }
                }
            }
            
            // 创建记录目录
            var isDir: ObjCBool = false
            if !FileManager.default.fileExists(atPath: recordDir, isDirectory: &isDir) {
                try? FileManager.default.createDirectory(atPath: recordDir, withIntermediateDirectories: true)
            }
            
            // 执行上传
            let resumeTask = self.client.resumableUpload(upload)
            
            // 处理上传结果
            resumeTask.continue({ [weak self] task in
                guard let self = self else { return nil }
                
                // 确保在主线程处理结果
                DispatchQueue.main.async {
                    // 最后一次进度更新
                    if let result = task.result as? OSSResumableUploadResult {
                        self.channel.invokeMethod("uploadProgress", arguments: [
                            "current": fileSize,
                            "total": fileSize,
                            "taskId": taskId
                        ])
                    }
                    
                    if let error = task.error as? NSError {
                        if error.code == 5 {
                            self.channel.invokeMethod("uploadResult", arguments: [
                                "success": 0,
                                "taskId": taskId,
                                "cancel": 1,
                                "message": error.localizedDescription
                            ])
                        } else {
                            self.channel.invokeMethod("uploadResult", arguments: [
                                "success": 0,
                                "taskId": taskId,
                                "cancel": 0,
                                "message": error.localizedDescription
                            ])
                        }
                    } else {
                        self.channel.invokeMethod("uploadResult", arguments: [
                            "success": 1,
                            "taskId": taskId
                        ])
                    }
                }
                return nil
            })
            
            // 保存任务引用
            managerTask.task = resumeTask
            managerTask.request = upload
            self.taskMap[taskId] = managerTask
            
            // 返回任务ID
            DispatchQueue.main.async {
                result(taskId)
            }
        }
    }
    
    func asyncResumableDownload(_ call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments as? [String: Any?] else {
            result(0)
            return
        }
        guard let bucketName = args["bucketName"] as? String else {
            result(0)
            return
        }
        guard let ossFileName = args["ossFileName"] as? String else {
            result(0)
            return
        }
        guard let filePath = args["filePath"] as? String else {
            result(0)
            return
        }
        guard let recordDir = args["recordFile"] as? String else {
            result(0)
            return
        }
        
        let managerTask = FOssClientTask()
        let taskId = "\(managerTask.hash)"
        taskMap[taskId] = managerTask
        DispatchQueue.global().async {[weak self] in
            var isDir: ObjCBool = false
            if !FileManager.default.fileExists(atPath: recordDir, isDirectory: &isDir) {
                try? FileManager.default.createDirectory(atPath: recordDir, withIntermediateDirectories: true)
            }
            let headObject = self?.getFileInfo(bucketName: bucketName, objectKey: ossFileName)
            if headObject == nil{
                DispatchQueue.main.async {
                    self?.channel.invokeMethod("downloadResult", arguments: [
                        "success":0,
                        "taskId": taskId,
                        "cancel":0,
                        "message": "获取元数据失败"
                    ])
                }
                return
            }
            print(headObject!.objectMeta)
            let md5 = headObject!.objectMeta["ETag"]
            let totalSize:Int64 = Int64((headObject!.objectMeta["Content-Length"] as? String) ?? "0") ?? 0
            //判断记录文件是否存在
            let recordFile = "\(recordDir)/\(String(describing: md5))"
            if !FileManager.default.fileExists(atPath: recordFile, isDirectory: &isDir) {
                FileManager.default.createFile(atPath: recordFile, contents: nil)
            }
            //获取本地文件大小
            if !FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir) {
                FileManager.default.createFile(atPath: filePath, contents: nil)
            }
            let attrs = try? FileManager.default.attributesOfItem(atPath: filePath)
            if attrs == nil {
                return
            }
            print(attrs!)
            let fileSize:Int64 = (attrs![FileAttributeKey.size] as? Int64) ?? 0
            print(totalSize)
            print(fileSize)
            if (fileSize >= totalSize){
                result(taskId)
                DispatchQueue.main.async {
                    self?.channel.invokeMethod("downloadProgress", arguments: [
                        "current": totalSize,
                        "total": totalSize,
                        "taskId": taskId
                    ])
                    self?.channel.invokeMethod("downloadResult", arguments: [
                        "success":1,
                        "taskId": taskId
                    ])
                }
                return
            }
            var headMap = [String:String]()
            let request = OSSGetObjectRequest()
            if let limit = self?.speedLimit {
                if (limit > 0){
                    headMap["x-oss-traffic-limit"] = "\(limit)"
                }
            }
            headMap["Range"] = "bytes=\(fileSize)-"
            print(headMap)
            request.headerFields = headMap
            request.bucketName = bucketName
            request.objectKey = ossFileName
            request.onRecieveData = { data in
                let handler = FileHandle.init(forWritingAtPath: filePath)
                if #available(iOS 13.4, *) {
                    try? handler?.seekToEnd()
                    handler?.write(data)
                    try? handler?.close()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            // 可选字段。
            request.downloadProgress = {[weak self] bytesWritten, totalBytesWritten,totalBytesExpectedToWrite in
                // 当前下载段长度、当前已经下载总长度、一共需要下载的总长度。
                if (totalBytesExpectedToWrite == 0){
                    return
                }
                DispatchQueue.main.async {
                    self?.channel.invokeMethod("downloadProgress", arguments: [
                        "current": totalBytesWritten + fileSize,
                        "total": totalSize,
                        "taskId": taskId
                    ])
                }
            };
            let getTask = self?.client.getObject(request)
            getTask?.continue({[weak self] task in
                if let error = task.error as? NSError {
                    if (error.code == 5){
                        //用户取消
                        DispatchQueue.main.async {
                            self?.channel.invokeMethod("downloadResult", arguments: [
                                "success":0,
                                "taskId": taskId,
                                "cancel":1,
                                "message": error.localizedDescription
                            ])
                        }
                    }else{
                        DispatchQueue.main.async {
                            self?.channel.invokeMethod("downloadResult", arguments: [
                                "success":0,
                                "taskId": taskId,
                                "cancel":0,
                                "message": error.localizedDescription
                            ])
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.channel.invokeMethod("downloadResult", arguments: [
                            "success":1,
                            "taskId": taskId
                        ])
                    }
                }
                return nil
            })
            managerTask.task = getTask
            managerTask.request = request
            result(taskId)
        }
        
    }
    
    func checkFile(_ call: FlutterMethodCall,result: @escaping FlutterResult){
        
    }
    
    func getSignUrl(_ call: FlutterMethodCall,result: @escaping FlutterResult){
        
    }
    
    func cancelTask(taskId: String) {
        if let managerTask = taskMap[taskId],
           let ossTask = managerTask.task {
            if !ossTask.isCancelled && !ossTask.isCompleted {
                managerTask.request?.cancel()
                ossTask.waitUntilFinished() // 等待任务完全取消
                taskMap.removeValue(forKey: taskId)
            }
        }
    }
    
    func cancelAllTask() {
        taskMap.values.forEach { task in
            if let ossTask = task.task,
               !ossTask.isCancelled && !ossTask.isCompleted {
                task.request?.cancel()
                ossTask.waitUntilFinished() // 等待每个任务完全取消
            }
        }
        taskMap.removeAll()
    }
    
    private func getFileInfo(bucketName:String,objectKey:String)-> OSSHeadObjectResult?{
        let request = OSSHeadObjectRequest()
        request.bucketName = bucketName
        request.objectKey = objectKey
        let task = client.headObject(request)
        var headResult: OSSHeadObjectResult?
        task.continue({ t in
            if (task.error == nil){
                headResult = task.result as? OSSHeadObjectResult
            }
            return nil
        })
        task.waitUntilFinished()
        return headResult
    }

    
//    public void checkFile(MethodCall call, MethodChannel.Result result){
//           String bucketName = call.argument("bucketName");
//           String fileName = call.argument("fileName");
//           try {
//              boolean r = mOss.doesObjectExist(bucketName, fileName);
//              result.success(r ? 1 : 0);
//           }catch (Exception e){
//               result.success(0);
//           }
//       }
//
//       public void getSignUrl(MethodCall call, MethodChannel.Result result){
//           String bucketName = call.argument("bucketName");
//           String fileName = call.argument("fileName");
//          String r = mOss.presignPublicObjectURL(bucketName,fileName);
//          result.success(r);
//       }
//
//       public void cancelTask(String taskId){
//           OSSAsyncTask task = taskMap.get(taskId);
//           if (task != null && !task.isCanceled() && !task.isCompleted()) {
//               taskMap.remove(taskId);
//               task.cancel();
//           }
//       }
//
//       public void cancelAllTask(){
//           for (String key : taskMap.keySet()) {
//               OSSAsyncTask task = taskMap.get(key);
//               if (task != null && !task.isCanceled() && !task.isCompleted()) {
//                   taskMap.remove(key);
//                   task.cancel();
//               }
//           }
//           taskMap.clear();
//       }
//
//       @SuppressLint("DefaultLocale")
//       private String createTaskId(){
//           StringBuilder randomStr = new StringBuilder();
//           for (int i = 0; i < 4; i++) {
//               randomStr.append(String.format("%02d",(new Random()).nextInt(10000) % 100));
//           }
//           return System.currentTimeMillis() + randomStr.toString();
//       }
}
