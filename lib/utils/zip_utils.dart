import 'dart:io';

/// 检查ZIP文件是否加密（快速检测，只读取文件头）
Future<int> isZipEncrypted(File file) async {

  final raf = await file.open(mode: FileMode.read);
  try {
    final headerBytes = await raf.read(1024);
    for (int i = 0; i < headerBytes.length - 30; i++) {
      if (headerBytes[i] == 0x50 && headerBytes[i + 1] == 0x4B && 
          headerBytes[i + 2] == 0x03 && headerBytes[i + 3] == 0x04) {
        int flag = headerBytes[i + 6];
        if ((flag & 0x1) == 0x1) {
          return 1;
        }
      }
    }
    return 0;
  } finally {
    await raf.close();
  }
}