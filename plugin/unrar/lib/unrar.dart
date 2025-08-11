import 'dart:async';
import 'package:flutter/services.dart';



class Unrar {
  
  // 方法通道常量
    static const MethodChannel _channel = MethodChannel('unrar_file');

    /// 解压 RAR 文件
    /// [filePath]    : 要解压的 RAR 文件路径
    /// [destinationPath] : 解压目标目录
    /// [password]     : 可选密码（默认为空）
    static Future<Map<dynamic, dynamic>> extractRAR({ required String filePath,required String destinationPath, password = "" }) async {
        try {
            // 调用原生平台方法进行解压
            var result = await _channel.invokeMethod('extractFile', {
                "file_path": filePath,
                "destination_path": destinationPath,
                "password": password
            });

            return result;
        }catch(e) {
            // 处理 RAR5 格式的特殊情况
            rethrow;
        }
    }

    /// 解压 RAR 文件
    /// [filePath]    : 要解压的 RAR 文件路径
    /// [destinationPath] : 解压目标目录
    /// [password]     : 可选密码（默认为空）
    static Future<Map<dynamic, dynamic>> listFileInfo({ required String filePath,required String destinationPath, password = "" }) async {
        try {
            // 调用原生平台方法进行解压
            var result = await _channel.invokeMethod('listFileInfo', {
                "file_path": filePath,
                "destination_path": destinationPath,
                "password": password
            });

            return result;
        }catch(e) {
            // 处理 RAR5 格式的特殊情况
            rethrow;
        }
    }

  
}
