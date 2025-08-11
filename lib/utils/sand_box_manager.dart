import 'package:path_provider/path_provider.dart';

/// iOS沙箱管理器
class SandboxManager {
  /// 获取当前应用的沙箱ID
  static Future<String> getCurrentSandboxId() async {
    try {
      // 获取应用文档目录
      final directory = await getApplicationDocumentsDirectory();
      final sandboxPath = directory.path;
      
      // 从路径中提取沙箱ID
      // 路径格式类似：/var/mobile/Containers/Data/Application/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/Documents
      final sandboxIdMatch = RegExp(r'Application/([A-Z0-9-]+)/').firstMatch(sandboxPath);
      if (sandboxIdMatch != null && sandboxIdMatch.groupCount >= 1) {
        return sandboxIdMatch.group(1)!;
      }
      return '';
    } catch (e) {
      rethrow;
    }
  }

  /// 更新文本中的所有沙箱ID
  static Future<String> updateSandboxIds(String originalText) async {
    final currentSandboxId = await getCurrentSandboxId();
    
    // 替换所有应用路径中的沙箱ID
    final pathPattern = RegExp(r'Application/[A-Z0-9-]+/');
    return originalText.replaceAllMapped(pathPattern, (match) {
      return 'Application/$currentSandboxId/';
    });
  }
}