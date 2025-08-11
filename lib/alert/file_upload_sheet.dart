import 'package:desk_cloud/alert/mobile_file/mobile_file_image_video_sheet.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

Future<dynamic> showFileUploadSheet({ required int dirId }) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _FileUploadView(dirId: dirId);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}


class _FileUploadView extends StatefulWidget {
  final int dirId;
  const _FileUploadView({ required this.dirId, super.key});

  @override
  State<_FileUploadView> createState() => _FileUploadViewState();
}

class _FileUploadViewState extends BaseXState<_FileUploadLogic, _FileUploadView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 375.w,
          height: 213.w + safeAreaBottom,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: 20.radius),
              color: kF8()
          ),
          // padding: EdgeInsets.all(16.w),
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Padding(
            padding: EdgeInsets.only(top: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText('上传文件', color: k3(), size: 18.sp,),
                    spaceW(12),
                    if (user.memberEquity.value!.vipStatus != 1)
                      MyButton(
                        width: 94.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [hexColor('#F48200'),hexColor('#C25E00')]),
                          borderRadius: 6.borderRadius
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyText('升级大文件上传',color: hexColor('#FFF5EC'),size: 10.sp,),
                            spaceW(3),
                            Image.asset(R.assetsUploadArrow,width: 6.w,height: 6.w,)
                          ],
                        ),
                        onTap: () async {
                          pop();
                          await showOpenMemberSheet(openMemberType: OpenMemberType.largeFileUpload);
                        },
                      )
                  ],
                ),
                spaceH(2),
                MyText(
                  '限上传${user.memberEquity.value?.vipStatus == 1 ? memberLogic.vipPowersEntity.value?.maxUploadSize?.vip1?.value ?? '' : memberLogic.vipPowersEntity.value?.maxUploadSize?.vip0?.value}文件',
                  color: k9(),
                  size: 11.sp
                ),
                spaceH(20),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.w),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 60.w / 73.w,
                        crossAxisSpacing: 29.w,
                    ),
                    itemBuilder: (context, index) {
                      var item = logic.options[index];
                      return InkWell(
                        onTap: item.action,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 60.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                    color: kWhite(),
                                    borderRadius: 15.borderRadius
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(item.icon!, width: 28.w, height: 28.w,)
                            ),
                            MyText(item.title!, color: k3(), size: 11.sp,)
                          ],
                        ),
                      );
                    },
                    itemCount: logic.options.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: MyText('响应净网行动，严禁传播色情违法内容，否则封号', color: kB3(), size: 10.sp,),
                ),
                spaceH(10)
              ],
            ),
          ),
        ),
        Positioned(
          right: 16.w,
          top: 16.w,
          child: GestureDetector(
            onTap: () {
              pop(context: context);
            },
            child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
          ),
        )
      ],
    );
  }

  @override
  _FileUploadLogic get initController => _FileUploadLogic(dirId: widget.dirId);
}

class _FileUploadLogic extends BaseLogic {

  final int dirId;
  _FileUploadLogic({ required this.dirId});

  late final options = [
    OptionEntity()
      ..title = '本地图片'
      ..icon = R.assetsUploadImage
      ..action = () {
        uploadAction(0);
      },
    OptionEntity()
      ..title = '视频'
      ..icon = R.assetsUploadVideo
      ..action = () {
        uploadAction(1);
      },
    OptionEntity()
      ..title = '文档'
      ..icon = R.assetsUploadDocument
      ..action = () {
        uploadAction(2);
      },
    OptionEntity()
      ..title = '新建文件夹'
      ..icon = R.assetsUploadDir
      ..action = () {
        uploadAction(3);
      }
  ];

  uploadAction(int type) async {
    if (type == 0) {
      pop();
      /// 先获取权限
      var res = await requestMyPhotosPermission(androidPermission: Permission.photos);
      if (!res) return;
      showMobileImageVideoSheet(mediumType: MediumType.image);
    }
    if (type == 1){
      pop();
      var res = await requestMyPhotosPermission(androidPermission: Permission.videos);
      if (!res) return;
      showMobileImageVideoSheet(mediumType: MediumType.video);
    }
    if (type == 2){
      pop();
      await oss.fileSelectedAciont();
    } 
    if (type == 3) {
      var res = await user.createDir(dirId);
      pop(args: res);
    }
  }

}
