import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'extension.dart';

/// 文件打开工具类
class FileOpenerUtil {
  /// 打开文件选择器
  /// [filePath] 可以是本地路径或网络URL
  static Future<void> openWith(String filePath) async {
    try {
      if (filePath.startsWith('http')) {
        // 处理网络文件
        await _handleNetworkFile(filePath);
      } else {
        // 处理本地文件
        await _openWithSystemChooser(filePath);
      }
    } catch (e) {
      showShortToast('打开文件失败: $e');
    }
  }

  /// 处理网络文件
  static Future<void> _handleNetworkFile(String url) async {
    try {
      showLoading('准备打开文件...');
      
      // 获取文件名并处理长文件名
      String fileName = url.split('/').last;
      // 从 URL 参数中提取原始文件名（如果存在）
      if (fileName.contains('?')) {
        fileName = fileName.split('?')[0];
      }
      
      // 如果文件名仍然过长，进行截断处理
      if (fileName.length > 50) {
        final extension = fileName.getFileExtension();
        fileName = '${fileName.substring(0, 46)}$extension';
      }
      
      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName';
      
      
      // 检查文件是否已存在
      final file = File(tempPath);
      if (!await file.exists()) {
        // 下载文件
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          dismissLoading();
          showShortToast('文件下载失败');
          return;
        }
      }
      
      dismissLoading();
      // 打开文件选择器
      await _openWithSystemChooser(tempPath);
    } catch (e) {
      dismissLoading();
      showShortToast('处理文件失败: $e');
    }
  }

  /// 调用系统选择器打开文件
  static Future<void> _openWithSystemChooser(String filePath) async {
    try {
      final result = await OpenFilex.open(
        filePath,
        type: '', // 留空让系统自动判断文件类型
        uti: '', // 留空让系统自动判断文件类型
      );

      if (result.type != ResultType.done) {
        showShortToast('打开失败: ${result.message}');
      }
    } catch (e) {
      showShortToast('打开文件选择器失败: $e');
    }
  }
} 

extension StringExtension on String {
  /// 获取文件扩展名（包含点号）
  String getFileExtension() {
    final index = lastIndexOf('.');
    if (index != -1) {
      return substring(index);
    }
    return '';
  }
}