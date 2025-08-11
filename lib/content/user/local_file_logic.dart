import 'dart:io';

import 'package:desk_cloud/utils/export.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LocalFileLogic extends BaseLogic {

    /// 新增方法：检测路径目录是否存在（不修改现有代码）
    /// [fullPath] 完整文件路径或目录路径
    /// [autoCreate] 当目录不存在时是否自动创建
    /// 返回：目录是否存在（创建成功视为存在）
    Future<bool> checkAndCreatePath(String fullPath, {bool autoCreate = false}) async {
        try {
            // 智能识别文件/目录路径
            final isDirectory = fullPath.endsWith('/');
            final Directory targetDir = isDirectory 
                ? Directory(fullPath) 
                : File(fullPath).parent;
            
            // 检查目录是否存在
            final dirExists = await targetDir.exists();
            
            // 自动创建逻辑
            if (!dirExists && autoCreate) {
                await targetDir.create(recursive: true);
                return await targetDir.exists();
            }
            
            return dirExists;
        } catch (e) {
            print('目录操作失败: $e');
            return false;
        }
    }

	/// 获取压缩文件的解压目录路径（支持多级扩展名）
    /// 支持格式：.zip .rar .7z .tar .tar.gz .tar.xz .tar.bz2 
    /// [archivePath] 压缩文件完整路径
    /// 返回示例：输入 /a/b/test.tar.gz 返回 /a/b/test/
    String getExtractDirectory(String archivePath) {
        // 定义支持的多级扩展名列表（按长度倒序排列）
        const extensions = [
            '.tar.xz', '.tar.bz2', '.tar.gz',  // 三级扩展名
            '.tar', '.zip', '.rar', '.7z',      // 二级扩展名
            '.gz', '.bz2'                       // 单级扩展名
        ];

        final file = File(archivePath);
		final fileName = file.uri.pathSegments.last;
		
		// 转换为小写进行扩展名匹配
		final lowerFileName = fileName.toLowerCase();
		
		// 查找最长的匹配扩展名
		String matchedExt = "zip";
		for (final ext in extensions) {
			if (lowerFileName.endsWith(ext)) {
				matchedExt = ext;
				break; // 按倒序排列后第一个匹配即最长
			}
		}

		// 计算原始文件名中的扩展名长度（保持大小写敏感）
		final originalExt = fileName.substring(fileName.length - matchedExt.length);
		
		// 构建基础目录名（去除完整扩展名）
		final baseName = fileName.substring(0, fileName.length - originalExt.length);
		
		// 返回标准化目录路径
		return '${file.parent.path}/$baseName/';
    }

    /// 原有方法保持不变 >>>>
    openOtherApplications(String localPath) async {
        File? file = await getLocalFile(localPath);
        if (file == null) {
            showShortToast('文件已失效，请重新下载');
            return;
        }
        if (Platform.isAndroid) {
            OpenFilex.open(file.path);
        } else {
            Share.shareXFiles([XFile(file.path)], subject: file.path.split('/').last);
        }
    }

    Future<File?> getLocalFile(String localPath) async {
        if (localPath.isEmpty) {
            return null;
        }

        File file;

        if (Platform.isIOS) {
            final docDir = await getApplicationDocumentsDirectory();
            
            String fullPath;
            final documentsIndex = localPath.indexOf('Documents');
            
            if (documentsIndex != -1) {
                final relativePath = localPath.substring(documentsIndex + 'Documents'.length);
                fullPath = '${docDir.path}$relativePath';
            } else {
                fullPath = '${docDir.path}$localPath';
            }
            
            file = File(fullPath);
        } else {
            file = File(localPath);
        }

        if (await file.exists()) {
            return file;
        }

        return null;
    }
    /// 原有方法结束 <<<<

}

// 全局实例化方法保持原样
LocalFileLogic get localFileLogic {
    if (Get.isRegistered<LocalFileLogic>()){
        return Get.find<LocalFileLogic>();
    }
    return Get.put(LocalFileLogic());
}
