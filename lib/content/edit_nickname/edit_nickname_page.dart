import 'package:desk_cloud/content/edit_nickname/edit_nickname_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditNickNamePage extends StatefulWidget {
  const EditNickNamePage({super.key});

  @override
  State<EditNickNamePage> createState() => _EditNickNamePageState();
}

class _EditNickNamePageState extends BaseXState<EditNickNameLogin, EditNickNamePage> {



  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          title: MyText(
            '修改昵称',
            size: 16.sp,
          ),
          leading: MyButton(
            title: '取消',
            padding: EdgeInsets.only(left: 16.w),
            decoration: const BoxDecoration(
              color: Colors.transparent
            ),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.normal,
              color: k3()
            ),
            onTap: () => pop(),
          ),
          actions: [
            MyButton(
              margin: EdgeInsets.only(right: 16.w),
              title: '确定',
              width: 52.w,
              height: 28.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: 8.borderRadius,
                color: k4A83FF()
              ),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.normal,
                color: kWhite()
              ),
              onTap: () => editNickNameLogin.editNickName(),
            )
          ],
        ),
        body: Column(
          children: [
            spaceH(24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 50.h,
                padding: EdgeInsets.only(left: 20.w, right: 16.w),
                decoration: BoxDecoration(
                  color: kWhite(),
                  borderRadius: 16.borderRadius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: MyTextField(
                      controller: editNickNameLogin.textEditingController,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: kBlack()
                      ),
                      onChanged: (value) {
                        editNickNameLogin.nickname = value;
                      },
                    )),
                    IconButton(
                      onPressed: () {
                        editNickNameLogin.textEditingController.text = '';
                      }, 
                      icon: Image.asset(
                        R.assetsDialogClose,
                        width: 24.w,
                        height: 24.w,
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  @override
  EditNickNameLogin get initController => EditNickNameLogin();
}