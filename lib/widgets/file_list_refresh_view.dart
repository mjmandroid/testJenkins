import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:desk_cloud/widgets/file_item_view.dart';
import 'package:flutter/material.dart';

class FileListRefreshView extends StatelessWidget {
  final RefreshController controller;
  final Function()? onRefresh;
  final Function()? onLoading;
  final bool enablePullUp;
  final Rx<DiskFileEntity> rxFile;
  final ValueChanged<DiskFileEntity>? onNext;
  final ValueChanged<DiskFileEntity>? onSelectedChange;
  final ValueChanged<DiskFileEntity>? onClickedPreview;
  final String? emptyText;
  final double? showBottomBarHeight;

  const FileListRefreshView({super.key, required this.controller, required this.rxFile, this.emptyText,this.enablePullUp = true, this.onRefresh, this.onLoading, this.onNext, this.onSelectedChange, this.onClickedPreview, this.showBottomBarHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (rxFile.value.subs?.isNotEmpty == true) return Container();
          return Container(
            // height: 375.w,
            alignment: Alignment.center,
            child: EmptyView(title: emptyText,),
          );
        }),
        Obx(() {
          return Column(
            children: [
              Expanded(child: SmartRefresher(
                controller: controller,
                onRefresh: onRefresh,
                onLoading: onLoading,
                enablePullUp: enablePullUp,
                // footer: ClassicFooter(
                //   noDataText: rxFile.value.subs?.isNotEmpty != true ? '' : null,
                // ),
                footer: MyCustomFooter(
                  noDataText: rxFile.value.subs?.isNotEmpty != true ? '' : null,
                ),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      var item = rxFile.value.subs?[index];
                      if (item == null) return Container();
                      return FileItemView(item, parent: rxFile.value, onNext: onNext, onSelectedChange: onSelectedChange, onClickedPreview: onClickedPreview);
                    },
                    separatorBuilder: (context, index) {
                      return spaceW(0);
                    },
                    itemCount: rxFile.value.subs?.length ?? 0
                ),
              )),
              // Container(height: tabParentLogic.optionC?.showing.value ?? false ? 110.w : 0, color: kF8())
              Container(height: showBottomBarHeight, color: Colors.transparent)
            ],
          );
        }),
      ],
    );
  }
}
