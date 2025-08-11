import 'package:desk_cloud/content/file/file_search_page.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class FileSearchBar extends StatelessWidget {
  const FileSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showFileSearch('');
      },
      child: Container(
        width: 343.w,
        height: 36.w,
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 3.w),
        decoration: BoxDecoration(
            color: kWhite(),
            borderRadius: 12.borderRadius
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Image.asset(R.assetsFileSearch, width: 24.w, height: 24.w,),
            spaceW(6),
            Expanded(
              child: MyTextField(
                hintText: '搜索网盘文件',
                hintStyle: TextStyle(fontSize: 13.sp, color: k9(), fontWeight: FontWeight.normal),
                style: TextStyle(fontSize: 13.sp, color: k3(), fontWeight: FontWeight.normal),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}