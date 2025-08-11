import 'package:desk_cloud/utils/export.dart';
import 'package:file_preview/file_preview.dart';
import 'package:flutter/material.dart';

class TxtPreviewPage extends StatefulWidget {

  final String url;

  const TxtPreviewPage(this.url, {super.key});

  @override
  State<TxtPreviewPage> createState() => _TxtPreviewPageState();
}

class _TxtPreviewPageState extends State<TxtPreviewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          '文件预览'
        ),
      ),
      body: FilePreviewWidget(
        width: 375.w, 
        height: 812.h, 
        path: widget.url
      )
    );
  }
}
