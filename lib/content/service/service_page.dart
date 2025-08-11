import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kF5(),
      appBar: MyAppBar(
        backgroundColor: kF5(),
        title: MyText('客服中心'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildItem(title: '在线客服', image: R.assetsIcService, subTitle: '人工线上快速解决您的问题，服务时间：9:00-18:00', subImage: R.assetsIcServiceQuick, onTap: () {
              user.jumpService();
            }),
            _buildItem(title: '常见问题', image: R.assetsIcFaq, subTitle: '为您提供各项问题的自主解决方法', onTap: () {
              push(MyRouter.webView, args: {'title': '常见问题', 'url': user.appInitData.value?.webview?.faq});
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({required String title, required String image, required GestureTapCallback onTap, required String subTitle, String? subImage}) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
      child: MyInkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: 16.borderRadius
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(image, width: 22.w, height: 22.w),
                  spaceW(8.w),
                  MyText(title, size: 15.sp, weight: FontWeight.bold),
                  spaceW(8.w),
                  if (subImage != null) Image.asset(subImage, width: 50.w, height: 14.5.w),
                ],
              ),
              spaceH(6.w),
              MyText(subTitle, size: 12.sp, color: k9()),
            ],
          ),
        ),
      ),
    );
  }
}