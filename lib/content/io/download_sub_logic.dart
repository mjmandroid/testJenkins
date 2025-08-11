import 'dart:io';

import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/alert/normal_input_sheet.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/preview/video_page.dart';
import 'package:desk_cloud/content/user/local_file_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unrar/unrar.dart';

class DownloadSubLogic extends BaseLogic {
  clickFile(FileIoDataRM item) async {
    File? file = await localFileLogic.getLocalFile(item.localPath ?? '');
    if (file == null) {
      showShortToast('文件已失效，请重新下载');
      return;
    }

    switch (item.fileType) {
      case 1:
        push(MyRouter.imagePreview, args: file.path);
        break;
      case 2:
        showVideoPage(pathUrl: file.path);
        break;
      case 5:
        if (Platform.isIOS) {
          push(MyRouter.wordPreview, args: file.path);
        } else {
          OpenFilex.open(file.path);
        }
        break;
      case 6:
        push(MyRouter.pdfPreview, args: file.path);
        break;
      case 8:
        if (user.memberEquity.value?.vipStatus == 0) {
          await showOpenMemberSheet(openMemberType: OpenMemberType.extractZip);
        } else {
          // 安卓和iOS通用解压逻辑
          // 安卓支持市场上大部分压缩文件格式 比如 rar zip 7z img iso ... 等等
          // iOS 支持 rar 和 zip
          String unPath =
              localFileLogic.getExtractDirectory(XFile(file.path).path);

          if (await localFileLogic.checkAndCreatePath(unPath)) {
            showShortToast('文件已解压');
            // 打开文件浏览选项
            _openUnzippedFilesPage(unPath);
          } else {
            var r = await showNormalDialog(title: '文件解压', message: '是否解压此文件');

            if (r == true) {
              var result = await Unrar.extractRAR(
                  filePath: file.path, destinationPath: unPath, password: "");
              if (result['status']) {
                showShortToast('解压成功');
                _openUnzippedFilesPage(unPath);
              } else {
                var password =
                    await showNormalInputSheet(title: '解压文件', hint: '输入解压密码');
                if (password == null || password.isEmpty) {
                  return;
                }
                var resultWithPassword = await Unrar.extractRAR(
                    filePath: file.path,
                    destinationPath: unPath,
                    password: password);
                if (resultWithPassword['status']) {
                  showShortToast('解压成功');
                  _openUnzippedFilesPage(unPath);
                } else {
                  showShortToast('密码错误');
                }
              }
            }
          }
        }
        break;
      default:
        OpenFilex.open(file.path);
        break;
    }

    // if (await file.exists() && !(item.fileType == 5 && Platform.isAndroid)) {
    //   if (item.fileType == 1) {
    //     push(MyRouter.imagePreview, args: file.path);
    //   } else if (item.fileType == 2) {
    //     showVideoPage(pathUrl: file.path);
    //   } else if (item.fileType == 5) {
    //     push(MyRouter.wordPreview, args: file.path);
    //   } else if (item.fileType == 6) {
    //     push(MyRouter.pdfPreview, args: file.path);
    //   } else if (item.fileType == 8) {
    //     if (user.memberEquity.value?.vipStatus == 0) {
    //       await showOpenMemberSheet(openMemberType: OpenMemberType.extractZip);
    //     } else {
    //       // showShortToast('该文件类型不支持在线预览,请保存到本机后再查看');
    //       // FileOpenerUtil.openWith(file.path ?? '');
    //       List<XFile> fileArr = [];
    //       fileArr.add(XFile(file.path));
    //       if (fileArr.isNotEmpty) {
    //         await Share.shareXFiles(fileArr);
    //       }
    //     }
    //   } else {
    //     // FileOpenerUtil.openWith(file.path ?? '');
    //     List<XFile> fileArr = [];
    //     fileArr.add(XFile(file.path));
    //     if (fileArr.isNotEmpty) {
    //       await Share.shareXFiles(fileArr);
    //     }
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
    //     showShortToast('文件失效，请重新下载');
    //   }
    // }
  }

  _openUnzippedFilesPage(String unPath) async {
    Get.toNamed(MyRouter.unzippedFiles, arguments: unPath);
  }
}
