import 'package:desk_cloud/content/feedback/feedback_login.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends BaseXState<FeedbackLogin, FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          title: MyText(
            '意见反馈',
            size: 16.sp,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 44.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.w),
                  child: MyText(
                    '请填写你的建议或反馈',
                    size: 16.sp,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h, bottom: 35.h),
                      decoration: BoxDecoration(
                        borderRadius: 16.borderRadius,
                        color: k3(0.04)
                      ),
                      constraints: BoxConstraints(
                        minHeight: 144.h
                      ),
                      child: MyTextField(
                        maxLength: 200,
                        maxLines: 999,
                        hintText: '请输入反馈内容',
                        controller: feedbackLogin.textEditingController,
                        hintStyle: TextStyle(
                          color: kB3(),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal
                        ),
                        style: TextStyle(
                          color: kBlack(),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal
                        ),
                        onChanged: (value) {
                          feedbackLogin.feedBackMsg.value = value;
                        },
                      ),
                    ),
                    Positioned(
                      right: 16.w,
                      bottom: 12.h,
                      child: Obx(() => MyText(
                        '${feedbackLogin.feedBackMsg.value.length}/200',
                        size: 11.sp,
                        color: kB3(),
                        weight: FontWeight.normal,
                      ))
                    )
                  ],
                ),
              ),
              spaceH(10),
              SizedBox(
                height: 44.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: MyText(
                    '上传图片',
                    size: 16.sp,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    width: 375.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                      child: Obx(() => Wrap(
                        spacing: 13.w,
                        runSpacing: 15.h,
                        children: _imageArrWidget(),
                      )),
                    ),
                  ),
                  Positioned(
                    right: 20.w,
                    bottom: 20.h,
                    child: Obx(() => MyText(
                      '${logic.imageUrls.length}/9',
                      size: 11.sp,
                      weight: FontWeight.normal,
                      color: kB3(),
                    ))
                  )
                ],
              ),
              spaceH(30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: MyButton(
                  alignment: Alignment.center,
                  height: 49.h,
                  title: '提交',
                  width: 327.w,
                  onTap: () {
                    logic.submitFeedBack();
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _imageArrWidget () {
    List<Widget> widgets = [];
    for (var i = 0; i < logic.imageUrls.length; i++) {
      widgets.add(
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5.w, right: 5.w),
              decoration: BoxDecoration(
                borderRadius: 16.borderRadius
              ),
              child: ClipRRect(
                borderRadius: 16.borderRadius,
                child: CachedNetworkImage(
                  imageUrl: logic.imageUrls[i],
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    R.assetsIcDefault,
                    width: 80.w,
                    height: 80.w,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    R.assetsIcDefault,
                    width: 80.w,
                    height: 80.w,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: MyButton(
                onTap: () {
                  logic.deleteImage(i);
                },
                decoration: BoxDecoration(
                  color: kWhite(),
                  borderRadius: 18.borderRadius
                ),
                child: Image.asset(
                  R.assetsIcClose,
                  width: 18.w,
                  height: 18.w,
                ),
              )
            )
          ],
        )
      );
    }
    if (logic.imageUrls.length < 9) {
      widgets.add(_addBtn());
    }
    return widgets;
  }

  Widget _addBtn() {
    return MyInkWell(
      onTap: () {
        logic.uploadImage(context);
      },
      child: Container(
        width: 80.w,
        height: 80.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: k3(.04),
          borderRadius: 16.borderRadius
        ),
        child: Image.asset(
          R.assetsIcAdd,
          width: 32.w,
          height: 32.w,
        ),
      ),
    );
  }
  
  @override
  FeedbackLogin get initController => FeedbackLogin();
}