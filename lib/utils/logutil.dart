import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

late Logger logger;

class MLogUtil {
  static init() async {
    // 日志目录
    Directory tempDir;
    if (Platform.isIOS) {
      tempDir = await getApplicationDocumentsDirectory();
    } else {
      tempDir =
          await getExternalStorageDirectory() ?? await getTemporaryDirectory();
    }

    // 初始化Log
    logger = Logger(
      filter: ProductionFilter(),
      level: Level.all,
      output: MyFileOutput(path: "${tempDir.path}/logs"),
      printer: PrettyPrinter(
        methodCount: 8,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );

    try {
      // 删除超过7天的日志记录
      List<FileSystemEntity> list = tempDir.listSync();
      for (var element in list) {
        if (basename(element.path).startsWith("log_")) {
          if (element
              .statSync()
              .modified
              .isBefore(DateTime.now().add(const Duration(days: -7)))) {
            element.deleteSync();
          }
        }
      }
    } catch (e) {
      logger.i(e);
    }
  }
}

class MyFileOutput extends AdvancedFileOutput {
  MyFileOutput({
    required super.path,
    super.fileNameFormatter = _defaultFileNameFormat,
  });

  static String _defaultFileNameFormat(DateTime t) {
    return "log_${DateFormat("yyyy-MM-dd HH:mm:ss").format(t)}.log";
  }

  @override
  void output(OutputEvent event) {
    super.output(event);
    for (var line in event.lines) {
      if (kDebugMode) print(line);
    }
  }
}

Future<String> shareLogs() async {
  Directory tempDir;
  if (Platform.isIOS) {
    tempDir = await getApplicationDocumentsDirectory();
  } else {
    tempDir =
        await getExternalStorageDirectory() ?? await getTemporaryDirectory();
  }
  var directoryPath = "${tempDir.path}/logs";
  var directoryPathTRTC =
      Platform.isAndroid ? "${tempDir.path}/log/liteav" : "${tempDir.path}/log";
  var outputPath = "${tempDir.path}/logs.zip";

  var d1 = Directory(directoryPath);
  var d2 = Directory(directoryPathTRTC);
  if (!d1.existsSync()) d1.createSync(recursive: true);
  if (!d2.existsSync()) d2.createSync(recursive: true);

  final archive = Archive();

  for (final fileOrDirectory in [...d1.listSync(), ...d2.listSync()]) {
    if (fileOrDirectory is File) {
      final data = await fileOrDirectory.readAsBytes();
      archive.addFile(
          ArchiveFile(basename(fileOrDirectory.path), data.length, data));
    }
  }

  final zipBytes = ZipEncoder().encode(archive);
  final zipFile = File(outputPath);
  await zipFile.writeAsBytes(zipBytes!);

  final result = await Share.shareXFiles([XFile(outputPath)], text: '发送日志');

  if (result.status == ShareResultStatus.success) {
    logger.i("日志发送成功");
  }

  return outputPath;
}
