import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_command_part.dart';
import 'package:desk_cloud/content/tabs/tab_file_part.dart';
import 'package:desk_cloud/content/tabs/tab_io_part.dart';
import 'package:desk_cloud/content/tabs/tab_member_part.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:desk_cloud/widgets/io_option/io_option_container.dart';
import 'package:flutter/material.dart';

class TabParentPage extends StatefulWidget {
  const TabParentPage({Key? key}) : super(key: key);

  @override
  State<TabParentPage> createState() => _TabParentPageState();
}

class _TabParentPageState extends BaseXState<TabParentLogic,TabParentPage> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logic.getClipboardContext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        logic.getClipboardContext();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return IoOptionContainer(
      onCreate: (icOption) {
        logic.ioOption = icOption;
      },
      child: FileOptionContainer(
        onCreate: (v){
          logic.optionC = v;
        },
        child: Material(
          color: Colors.white,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: logic.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          TabCommandPart(),
                          TabFilePart(),
                          TabIoPart(),
                          TabMemberPart()
                        ],
                      ),
                    ),
                    if (!isKeyboardVisible)
                      Container(
                        width: 428.w,
                        height: 48.w + safeAreaBottom,
                        decoration: BoxDecoration(
                            color: kWhite(),
                            boxShadow: [
                              BoxShadow(
                                  color: hexColor('#1F0098', 0.02),
                                  offset: Offset(0, -4.w),
                                  blurRadius: 12.w
                              )
                            ]
                        ),
                        alignment: Alignment.center,
                        child: Obx(() {
                          return Padding(
                            padding: EdgeInsets.only(bottom: safeAreaBottom),
                            child: Row(
                              children: logic.tabs.map((element) {
                                return _tabItem(element);
                              }).toList(),
                            ),
                          );
                        }),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _tabItem(OptionEntity item) {
    return Expanded(
      child: Center(
        child: Stack(
          children: [
            Center(
              child: () {
                var index = logic.tabs.indexOf(item);
                return SizedBox(
                  width: 93.75.w,
                  child: MyInkWell(
                    onTap: () {
                      // if (logic.currentIndex.value != index) {
                      //   logic.jumpToPage(index);
                      // }
                      logic.jumpToPage(index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ObxValue((data) {
                          return Image.asset(
                            data.value == index ? item.activeIcon ?? "" : item.icon ?? "",
                            fit: BoxFit.fill,
                            width: 24.w,
                            height: 24.w,
                          );
                        }, logic.currentIndex),
                        spaceH(2),
                        ObxValue((data) {
                          return MyText(item.title ?? '', size: 9.sp, color: data.value == index ? (item.activeColor ?? k4A83FF()) : (item.color ?? k6()));
                        },logic.currentIndex)
                      ],
                    ),
                  ),
                );
              }(),
            ),
            if ((item.count ?? 0) > 0)
              Positioned(
                right: 30.w,
                top: 5.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      color: hexColor('#FF0143'),
                      borderRadius: BorderRadius.circular(8.w)
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  TabParentLogic get initController => TabParentLogic();
}
