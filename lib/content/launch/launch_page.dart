import 'package:desk_cloud/content/launch/launch_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends BaseXState<LaunchLogic, LaunchPage> {
  @override
  Widget build(BuildContext context) {
    safeAreaTop = MediaQuery
        .of(context)
        .padding
        .top;
    safeAreaBottom = MediaQuery
        .of(context)
        .padding
        .bottom;
    return Material(
      color: kWhite(),
      // child: Obx(() {
      //   if (logic.path.value == null) return Container();
      //   return Image.file(File(logic.path.value!), fit: BoxFit.cover,);
      // }),
      child: Image.asset(R.assetsLaunchImage, fit: BoxFit.cover,),
    );
  }

  @override
  LaunchLogic get initController => LaunchLogic();
}
