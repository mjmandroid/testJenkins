import 'dart:io';

import 'package:desk_cloud/entity/upload_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FeedbackLogin extends BaseLogic {
  
  final TextEditingController textEditingController = TextEditingController();

  List<String> imageUrls = RxList<String>();
  List<String> imageUrlsTemp = [];
  var feedBackMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    imageUrls.clear();
    imageUrlsTemp.clear();
  }

  uploadImage(BuildContext context) async {
    var photosPermission = await requestMyPhotosPermission(androidPermission: Permission.photos);
    if (!photosPermission) return;

    // ignore: use_build_context_synchronously
    List<AssetEntity>? assetEntity = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 9 - imageUrls.length,
        requestType: RequestType.image
      )
    );
    if (assetEntity == null) return;
    showLoading();
    try {
      for (var entity in assetEntity) {
        final file = await entity.originFile;
        if (file == null) return;
        File fileToUpload;
        // 判断是否为GIF
        if (file.path.endsWith(".gif")) {
          // 压缩GIF，保留动画帧(未完成)
          fileToUpload = await compressGif(file);
        } else {
          // 对于JPEG或PNG，使用flutter_image_compress进行压缩
          fileToUpload = await compressImage(file);
        }
        var base = await ApiNet.uploadFile<UploadFileEntity>(Api.uploadFile, fileToUpload);
        imageUrls.add(base.data!.fullurl);
        imageUrlsTemp.add(base.data!.url);
      }
      dismissLoading();
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
  }

  deleteImage(int index) {
    imageUrls.removeAt(index);
    imageUrlsTemp.removeAt(index);
  }

  submitFeedBack() async {
    if (feedBackMsg.isEmpty) {
      showShortToast('请输入反馈内容');
      return;
    }
    try {
      await ApiNet.request(Api.userFeedback, data: {
        'content': feedBackMsg.value,
        'images': imageUrlsTemp.join(',')
      });
      showShortToast('反馈成功');
      pop();
    } catch (e) {
      showShortToast(e.toString());
    }
  }

}

FeedbackLogin get feedbackLogin {
  if (Get.isRegistered<FeedbackLogin>()){
    return Get.find<FeedbackLogin>();
  }
  return Get.put(FeedbackLogin());
}