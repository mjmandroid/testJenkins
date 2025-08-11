import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Word文件预览页面
class WordPreview extends StatefulWidget {
  final String filePath; // 可以是网络URL或本地文件路径

  const WordPreview(this.filePath, {Key? key}) : super(key: key);

  @override
  State<WordPreview> createState() => _WordPreviewState();
}

class _WordPreviewState extends State<WordPreview> {

  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
        },
      ));
    
    // 判断是否为网络文件
    if (widget.filePath.startsWith('http://') || widget.filePath.startsWith('https://')) {
      _controller.loadRequest(Uri.parse(_getPreviewUrl()));
    } else {
      // 本地文件直接加载
      _controller.loadFile(widget.filePath);
    }
  }

  String _getPreviewUrl() {
    // 使用Microsoft Office Online Viewer
    return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(widget.filePath)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: MyText(
          '预览'
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
} 
