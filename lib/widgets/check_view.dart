import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';


class CheckView extends StatelessWidget {
  final double size;
  final bool selected;
  const CheckView({Key? key,required this.size,this.selected = true,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (){
        if (selected){
          return Image.asset(
            R.assetsCheckRoundY,
            width: size,
            height: size,
          );
        }
        return Image.asset(
          R.assetsCheckRoundN,
          width: size,
          height: size,
        );
      }(),
    );
  }
}
