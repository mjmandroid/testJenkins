import 'package:desk_cloud/content/user/fake_downloader.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Example showing how to use the FakeDownloader
/// 
/// This is just a simple implementation to demonstrate the usage.
/// In a real-world scenario, you would want to integrate this with
/// your existing OssLogic by either extending it like in FakeOssLogic
/// or by modifying it directly.
class FakeDownloaderExample extends StatefulWidget {
  const FakeDownloaderExample({super.key});

  @override
  State<FakeDownloaderExample> createState() => _FakeDownloaderExampleState();
}

class _FakeDownloaderExampleState extends State<FakeDownloaderExample> {
  late final FakeDownloader _fakeDownloader;
  final _downloadProgress = <String, double>{}.obs;
  final _downloadStatus = <String, String>{}.obs;
  final OssLogic _ossLogic = Get.find<OssLogic>();

  @override
  void initState() {
    super.initState();
    _fakeDownloader = FakeDownloader(_ossLogic.client);
    
    // Listen to download progress
    _fakeDownloader.progressStream.listen((event) {
      final progress = event.current / event.total;
      _downloadProgress[event.taskId] = progress;
    });
    
    // Listen to download status
    _fakeDownloader.resultStream.listen((event) {
      if (event.success) {
        _downloadStatus[event.taskId] = "Completed";
      } else if (event.cancel) {
        _downloadStatus[event.taskId] = "Canceled";
      } else {
        _downloadStatus[event.taskId] = "Failed: ${event.message}";
      }
    });
  }

  @override
  void dispose() {
    _fakeDownloader.dispose();
    super.dispose();
  }

  Future<void> _startDownload(bool isVip) async {
    // For demonstration purposes, we're toggling the VIP status
    // In a real app, this would come from your user management system
    
    // Simulate getting file information from your API
    final bucketName = "example-bucket";
    final ossFileName = "example-file.mp4";
    final filePath = "/storage/emulated/0/Download/example-file.mp4";
    final recordFile = "/storage/emulated/0/Download/record";
    
    final taskId = await _fakeDownloader.download(
      bucketName: bucketName,
      ossFileName: ossFileName,
      filePath: filePath,
      recordFile: recordFile,
    );
    
    _downloadProgress[taskId] = 0.0;
    _downloadStatus[taskId] = "Downloading...";
  }

  void _cancelDownload(String taskId) async {
    await _fakeDownloader.cancelTask(taskId: taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fake Downloader Demo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _startDownload(false),
                  child: const Text('Start Non-VIP Download'),
                ),
                ElevatedButton(
                  onPressed: () => _startDownload(true),
                  child: const Text('Start VIP Download'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: _downloadProgress.length,
                itemBuilder: (context, index) {
                  final taskId = _downloadProgress.keys.elementAt(index);
                  final progress = _downloadProgress[taskId] ?? 0.0;
                  final status = _downloadStatus[taskId] ?? "Pending";
                  
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Task ID: $taskId'),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: progress),
                          const SizedBox(height: 8),
                          Text('Status: $status'),
                          const SizedBox(height: 8),
                          Text('Progress: ${(progress * 100).toStringAsFixed(1)}%'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _cancelDownload(taskId),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 