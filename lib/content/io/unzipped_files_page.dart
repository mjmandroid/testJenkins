import 'dart:io';

import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class UnzippedFilesPage extends StatefulWidget {
  final String path;

  const UnzippedFilesPage({super.key, required this.path});

  @override
  State<UnzippedFilesPage> createState() => _UnzippedFilesPageState();
}

class _UnzippedFilesPageState extends State<UnzippedFilesPage> {
  late Future<List<FileSystemEntity>> _entitiesFuture;
  late String _currentPath;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.path;
    _entitiesFuture = _loadFiles();
  }

  Future<List<FileSystemEntity>> _loadFiles() async {
    final dir = Directory(_currentPath);
    if (!await dir.exists()) {
      Get.snackbar('错误', '文件夹不存在');
      return [];
    }

    final entities = await dir.list().toList();

    entities.sort((a, b) {
      final aIsDir = a is Directory;
      final bIsDir = b is Directory;
      if (aIsDir && !bIsDir) return -1;
      if (!aIsDir && bIsDir) return 1;
      return p
          .basename(a.path)
          .toLowerCase()
          .compareTo(p.basename(b.path).toLowerCase());
    });

    return entities;
  }

  Future<void> _onItemTap(FileSystemEntity entity) async {
    if (entity is File) {
      final result = await OpenFilex.open(entity.path);
      if (result.type != ResultType.done) {
        Get.snackbar('提示', '无法打开该文件（${result.message}）');
      }
    } else if (entity is Directory) {
      // Use Get.to for nested navigation to keep the back stack
      Get.to(() => UnzippedFilesPage(path: entity.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: MyText(p.basename(_currentPath)),
        backgroundColor: kWhite(),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite(),
      body: ClipRRect(
        borderRadius: BorderRadius.vertical(top: 20.radius),
        child: Container(
          color: kWhite(),
          child: FutureBuilder<List<FileSystemEntity>>(
            future: _entitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('加载出错：${snapshot.error}'));
              }

              final entities = snapshot.data ?? [];
              if (entities.isEmpty) {
                return const Center(child: Text('文件夹是空的哟~'));
              }

              return ListView.builder(
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  final e = entities[index];
                  final isFile = e is File;

                  final diskFile = DiskFileEntity.fromJson({
                    'title': p.basename(e.path),
                    'is_dir': isFile ? 0 : 1,
                    'file_type': isFile
                        ? fileTypeFromExtension(
                            p.extension(e.path).substring(1))
                        : 0,
                    'dataType': 3,
                  });

                  return FileItemView(
                    diskFile,
                    parent: DiskFileEntity(),
                    onNext: (v) => _onItemTap(e),
                    onClickedPreview: (v) => _onItemTap(e),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

int fileTypeFromExtension(String extension) {
  switch (extension.toLowerCase()) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'bmp':
    case 'webp':
      return 1; // Image
    case 'mp4':
    case 'avi':
    case 'mkv':
    case 'mov':
    case 'flv':
      return 2; // Video
    case 'mp3':
    case 'wav':
    case 'flac':
      return 3; // Audio
    case 'txt':
      return 4; // Txt
    case 'doc':
    case 'docx':
      return 5; // Word
    case 'pdf':
      return 6; // PDF
    case 'xls':
    case 'xlsx':
      return 7; // Excel
    case 'zip':
    case 'rar':
    case '7z':
      return 8; // Zip
    case 'ppt':
    case 'pptx':
      return 9; // PPT
    default:
      return 0; // Unknown
  }
}
