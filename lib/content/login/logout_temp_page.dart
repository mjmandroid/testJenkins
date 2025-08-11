import 'dart:io';

import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_origin_resources/flutter_origin.dart';

showLogoutTemp(){
  CustomNavigatorObserver().navigator?.pushAndRemoveUntil(PageRouteBuilder(pageBuilder: (context,a1,a2){
    return const LogoutTempPage();
  },transitionDuration: Duration.zero), (route) => false);
}

class LogoutTempPage extends StatefulWidget {
  const LogoutTempPage({super.key});

  @override
  State<LogoutTempPage> createState() => _LogoutTempPageState();
}

class _LogoutTempPageState extends State<LogoutTempPage> {
  final path = Rxn<String>();

  @override
  void initState() {
    super.initState();
    FlutterOriginResources.getResourcePath('img_launch').then((value) => path.value = value);
    0.5.delay().then((value) => user.gotoLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite(),
      child: Obx(() {
        if (path.value == null) return Container();
        return Image.file(File(path.value!), fit: BoxFit.cover,);
      }),
    );
  }
}
