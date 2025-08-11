import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfPreview extends StatelessWidget {
  
  final String path;
  const PdfPreview(this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText('预览'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildPdfView(),
    );
  }

  /// 构建PDF视图
  /// 根据路径是否以 http 开头来判断是网络文件还是本地文件
  Widget _buildPdfView() {
    const pdfWidget = PDF(
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      fitEachPage: true,
      fitPolicy: FitPolicy.BOTH,
    );

    // 判断是否为网络路径
    if (path.startsWith('http')) {
      return pdfWidget.cachedFromUrl(
        path,
        placeholder: _buildLoadingWidget,
      );
    } else {
      return pdfWidget.fromPath(
        path
      );
    }
  }

  /// 构建加载进度指示器
  Widget _buildLoadingWidget(double progress) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: progress / 100,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            spaceH(16),
            MyText(
              '加载中...${progress.toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }
}