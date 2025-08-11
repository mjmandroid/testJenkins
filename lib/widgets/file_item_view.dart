import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:flutter/material.dart';

class FileItemView extends StatelessWidget {
  final DiskFileEntity item;
  final DiskFileEntity parent;
  final ValueChanged<DiskFileEntity>? onNext;
  final ValueChanged<DiskFileEntity>? onSelectedChange;
  final ValueChanged<DiskFileEntity>? onClickedPreview;
  const FileItemView(this.item,{super.key,required this.parent,this.onNext,this.onSelectedChange, this.onClickedPreview});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        item.selected = !(item.selected ?? false);
        onSelectedChange?.call(item);
      },
      onTap: () async {
        var list = parent.subs?.where((element) => element.selected == true).toList() ?? [];
        if (list.isEmpty){
          if (item.isDir == 1){
            onNext?.call(item);
          }else{
            if (item.fileType == 1 || item.fileType == 2 || item.fileType == 6 || item.fileType == 8) {
              onClickedPreview?.call(item);
            }  else {
              // item.selected = true;
              // onSelectedChange?.call(item);
              // showShortToast('该文件类型不支持在线预览,请下载后再查看');
              onClickedPreview?.call(item);
            }
          }
        }else{
          if (item.dataType == 3) return;
          item.selected = !(item.selected ?? false);
          onSelectedChange?.call(item);
        }
      },
      child: Container(
        height: 60.w,
        padding: EdgeInsets.only(left: 16.w),
        color: item.selected == true ? k4A83FF(0.1) : Colors.transparent,
        child: Row(
          children: [
            (item.fileType != 1 && item.fileType != 2) || item.thumb == null || item.thumb == '' ? 
              Image.asset(
                item.fileType?.fileTypeIcon ?? '', 
                width: 32.w, 
                height: 32.w
              ) : ClipRRect(
                  borderRadius: 3.borderRadius,
                  child: CachedNetworkImage(
                    imageUrl: item.thumb??'', 
                    width: 32.w,
                    height: 32.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      R.assetsIcDefault,
                      width: 32.w,
                      height: 32.w,
                      fit: BoxFit.cover
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      R.assetsIcDefault,
                      width: 32.w,
                      height: 32.w,
                      fit: BoxFit.cover
                    ),
                  )
                ),
            spaceW(16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    item.title ?? '', 
                    color: k3(), 
                    size: 13.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  spaceH(5),
                  Row(
                    children: [
                      MyText(item.createtime ?? '', color: k9(), size: 10.sp,),
                      spaceW(8),
                      item.isDir == 0 ? MyText(item.size ?? '', color: k9(), size: 10.sp,) : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            if (item.dataType != 3)
              InkWell(
                onTap: (){
                  item.selected = !(item.selected ?? false);
                  onSelectedChange?.call(item);
                },
                child: Container(
                  width: 46.w,
                  height: 60.w,
                  alignment: Alignment.center,
                  child: CheckView(size: 14.w, selected: item.selected ?? false,)
                )
              )
          ],
        ),
      ),
    );
  }
}
