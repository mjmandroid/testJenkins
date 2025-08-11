import 'package:desk_cloud/alert/command_sheet.dart';
import 'package:desk_cloud/alert/file_share_valid_sheet.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/entity/share_data_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> showFileShareSheet(List<DiskFileEntity> files) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _FileShareView(files);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}


class _FileShareView extends StatefulWidget {
  final List<DiskFileEntity> files;

  const _FileShareView(this.files);

  @override
  State<_FileShareView> createState() => _FileShareViewState();
}

class _FileShareViewState extends BaseXState<_FileShareLogic, _FileShareView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      // height: 444.w + safeAreaBottom,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: 20.radius),
          color: kF8()
      ),
      // padding: EdgeInsets.all(16.w),
      padding: EdgeInsets.only(top: 16.w, right: 16.w, left: 16.w, bottom: 16.w + safeAreaBottom),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                pop(context: context);
              },
              child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText('分享', color: k3(), size: 18.sp,)
                  ],
                ),
                spaceH(20),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 48 / 89,
                      crossAxisSpacing: 22.w,
                      mainAxisSpacing: 11.w
                  ),
                  itemBuilder: (context, index) {
                    var item = logic.options[index];
                    return InkWell(
                      onTap: item.action,
                      child: Column(
                        children: [
                          Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                  color: kWhite(),
                                  borderRadius: 15.borderRadius
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(item.icon!, width: 24.w, height: 24.w,)
                          ),
                          Expanded(
                            child: Center(child: MyText(item.title!, color: k3(), size: 11.sp,),),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: logic.options.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                ),
                spaceH(19),
                GestureDetector(
                  onTap: logic.dayAction,
                  child: Container(
                    width: 327.w,
                    height: 51.w,
                    decoration: BoxDecoration(
                        color: kWhite(),
                        borderRadius: 14.borderRadius
                    ),
                    padding: EdgeInsets.only(left: 24.w, right: 20.w),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Obx(() {
                                    return logic.recycleExpiredDays[logic.dayIndex.value] == -1 ?  Text.rich(TextSpan(
                                        children: [
                                          TextSpan(text: '永久', style: TextStyle(color: k4A83FF(), fontSize: 13.sp, fontWeight: FontWeight.w600)),
                                          TextSpan(text: '有效', style: TextStyle(color: k3(), fontSize: 13.sp, fontWeight: FontWeight.w600)),
                                        ]
                                    )): Text.rich(TextSpan(
                                        children: [
                                          TextSpan(text: '${logic.recycleExpiredDays[logic.dayIndex.value]}', style: TextStyle(color: k4A83FF(), fontSize: 13.sp, fontWeight: FontWeight.w600)),
                                          TextSpan(text: '天有效', style: TextStyle(color: k3(), fontSize: 13.sp, fontWeight: FontWeight.w600)),
                                        ]
                                    ));
                                  })
                                ],
                              ),
                              spaceH(3),
                              Obx(() {
                                return logic.recycleExpiredDays[logic.dayIndex.value] == -1 ? MyText('分享后永久有效', color: k9(), size: 10.sp,) : MyText('分享后${logic.recycleExpiredDays[logic.dayIndex.value]}天失效，无法继续访问', color: k9(), size: 10.sp,);
                              })
                            ],
                          ),
                        ),
                        Image.asset(R.assetsShareArrow, width: 24.w, height: 24.w,)
                      ],
                    ),
                  ),
                ),
                user.memberEquity.value!.roleType! == 2 && 1 == 2 ? Column(
                  children: [
                    spaceH(16),
                    GestureDetector(
                      onTap: logic.inputAction,
                      child: Container(
                        width: 327.w,
                        height: 51.w,
                        decoration: BoxDecoration(
                            color: kWhite(),
                            borderRadius: 14.borderRadius
                        ),
                        padding: EdgeInsets.only(left: 24.w, right: 20.w),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            MyText('口令', color: k3(), size: 13.sp,),
                            spaceW(10),
                            Expanded(
                                child: Obx(() => MyText(
                                  logic.commandCode.value.isEmpty ? '请输入选择口令' : logic.commandCode.value,
                                  size: 13.sp,
                                  color: k4A83FF(logic.commandCode.value.isEmpty ? .3 : 1),
                                  textAlign: TextAlign.right,
                                )),
                            ),
                            Image.asset(R.assetsShareArrow, width: 24.w, height: 24.w,)
                          ],
                        ),
                      ),
                    )
                  ],
                ) : spaceH(0),
                spaceH(16),
                Center(child: MyText('响应净网行动，严禁传播色情违法内容，否则封号', color: kB3(), size: 10.sp,))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  _FileShareLogic get initController => _FileShareLogic(widget.files);
}

class _FileShareLogic extends BaseLogic {
  final List<DiskFileEntity> files;
  var commandCode = ''.obs;
  final dayIndex = 0.obs;
  final recycleExpiredDays = user.memberEquity.value!.configInfo!.shareLinkExpiredDays ?? [];
  final shareData = Rxn<ShareDataEntity>();

  _FileShareLogic(this.files);

  late final options = [
    OptionEntity()
      ..title = '微信'
      ..icon = R.assetsShareWechat
      ..action = () {
        shareAction(0);
      },
    OptionEntity()
      ..title = '朋友圈'
      ..icon = R.assetsShareFriend
      ..action = () {
        shareAction(1);
      },
    OptionEntity()
      ..title = 'QQ'
      ..icon = R.assetsShareQq
      ..action = () {
        shareAction(2);
      },
    OptionEntity()
      ..title = 'QQ空间'
      ..icon = R.assetsShareSpace
      ..action = () {
        shareAction(3);
      },
    OptionEntity()
      ..title = '微博'
      ..icon = R.assetsShareWeibo
      ..action = () {
        shareAction(4);
      },
    if (user.memberEquity.value!.roleType! == 2 && 1 == 2)
    OptionEntity()
      ..title = '复制口令'
      ..icon = R.assetsShareCopy
      ..action = () {
        copyCode();
      },
    OptionEntity()
      ..title = '复制链接'
      ..icon = R.assetsShareLink
      ..action = () {
        copyLink();
      }
  ];

  // @override
  // void onInit() {
  //   super.onInit();
  //   refreshShareData();
  // }

  inputAction() async {
    var r = await showCommandSheet(files);
    if (r != null && r is String) {
      commandCode.value = r;
    } else if (r != null && !r) {
      commandCode.value = '';
    }
  }

  dayAction() async {
    var r = await showShareValidSheet(index: dayIndex.value, days: recycleExpiredDays);
    if (r == null) {
      return;
    }
    dayIndex.value = r;
  }

  refreshShareData()async{
    shareData.value = await user.diskCodeCreate(files, day: recycleExpiredDays[dayIndex.value].toString(),codes: commandCode.value, codeType: '2');
  }

  shareAction(int type) async {
    await refreshShareData();
    if (shareData.value == null) return;
    // if (shareData.value == null){
    //   showShortToast('分享数据出错，请稍后重试');
    //   return;
    // }
    switch(type){
      case 0: //微信
        user.wechatChatShare(shareData.value!);
        break;
      case 1: //朋友圈
        user.wechatTimelineShare(shareData.value!);
        break;
      case 2: //qq
        user.qqChatShare(shareData.value!);
        break;
      case 3: //qq空间
        user.qqSpaceShare(shareData.value!);
        break;
      case 4: //微博
        user.weiboShare(shareData.value!);
        break;
    }
    pop(args: true);
  }

  copyLink() async {
    await refreshShareData();
    if (shareData.value == null) return;
    // if (shareData.value?.txt?.isNotEmpty != true){
    //   showShortToast('链接出错，请稍后重试');
    //   return;
    // }
    Clipboard.setData(ClipboardData(text: shareData.value?.txt ?? ''));
    showShortToast('链接已复制到粘贴板');
    pop(args: true);
  }

  copyCode() async {
    if (commandCode.value.isEmpty) {
      showShortToast('请选择口令');
      return;
    }
    await refreshShareData();
    if (shareData.value == null) return;
    // if (shareData.value?.code?.isNotEmpty != true){
    //   showShortToast('口令出错，请稍后重试');
    //   return;
    // }
    Clipboard.setData(ClipboardData(text: shareData.value?.code ?? ''));
    showShortToast('口令已复制到粘贴板');
  }
}
