import 'dart:io';

import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatefulWidget {

  final String path;

  const ImagePreviewPage(this.path, {super.key});

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends BaseXState<ImagePreviewLogic, ImagePreviewPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack(),
      appBar: MyAppBar(
        title: MyText(
          '预览'
        ),
      ),
      body: Center(
        child: !logic.isNetwork.value ? PhotoView(
          imageProvider: FileImage(File(widget.path)),
          minScale: PhotoViewComputedScale.contained
        ) : PhotoView(
          imageProvider: NetworkImage(widget.path),
          minScale: PhotoViewComputedScale.contained
        ),
      ),
    );
  }
  
  @override
  ImagePreviewLogic get initController => ImagePreviewLogic(widget.path);
}

class ImagePreviewLogic extends BaseLogic {

  final String path;
  ImagePreviewLogic(this.path);

  var isNetwork = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    isNetwork.value = path.contains('http');
  }
  
}