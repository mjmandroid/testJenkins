import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/entity/preview_entity.dart';
import 'package:desk_cloud/utils/export.dart';

class UploadSubLogic extends BaseLogic{

  clickFile(FileIoDataRM item) async {
    // // 检查本地文件是否存在
    // final localPath = item.localPath;
    // if (localPath == null || localPath.isEmpty) {
    //   showShortToast('文件路径无效');
    //   return;
    // }
    
    // final file = File(localPath);
    // if (await file.exists() && !(item.fileType == 5 && Platform.isAndroid)) {
    //   if (item.fileType == 1) {
    //     push(MyRouter.imagePreview, args: item.localPath);
    //   } else if (item.fileType == 2) {
    //     showVideoPage(pathUrl: item.localPath ?? '');
    //   } else if (item.fileType == 5) {
    //     push(MyRouter.wordPreview, args: item.localPath);
    //   } else if (item.fileType == 6) {
    //     push(MyRouter.pdfPreview, args: item.localPath);
    //   } else if (item.fileType == 8) { 
    //     if (user.memberEquity.value?.vipStatus == 0) {
    //       await showOpenMemberSheet(openMemberType: OpenMemberType.extractZip);
    //     } else {
    //       // showShortToast('该文件类型不支持在线预览,请保存到本机后再查看');
    //       FileOpenerUtil.openWith(item.localPath ?? '');
    //     }
    //   } else {
    //     FileOpenerUtil.openWith(item.localPath ?? '');
    //   }
    // } else {
    //   if (item.fileId == null || item.fileId == 0) {
    //     showShortToast('文件不存在');
    //     return;
    //   }
    //   try {
    //     showLoading();
    //     var base = await ApiNet.request<PreviewEntity>(Api.aliyunGetUrl, data: {
    //       'file_id': item.fileId, 
    //       'type': item.fileType == 1 ? 'image' : 
    //               item.fileType == 2 ? 'video' : 
    //               item.fileType == 5 ? 'word' : 
    //               item.fileType == 6 ? 'pdf' : 
    //               item.fileType == 8 ? 'zip' : 'unknown'
    //     }); 
    //     tabParentLogic.showFilePreview(item.fileType, base.data?.url);
    //     dismissLoading();
    //   } catch (e) {
    //     dismissLoading();

    //   }
    // }

    if (item.fileId == null || item.fileId == 0) {
      showShortToast('文件不存在');
      return;
    }
    try {
      showLoading();
      var base = await ApiNet.request<PreviewEntity>(Api.aliyunGetUrl, data: {
        'file_id': item.fileId, 
        'type': item.fileType == 1 ? 'image' : 
                item.fileType == 2 ? 'video' : 
                item.fileType == 5 ? 'word' : 
                item.fileType == 6 ? 'pdf' : 
                item.fileType == 8 ? 'zip' : 'unknown'
      }); 
      tabParentLogic.showFilePreview(item.fileType, base.data?.url);
      dismissLoading();
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }

}