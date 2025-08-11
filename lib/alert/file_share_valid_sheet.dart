import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:flutter/material.dart';

Future<dynamic> showShareValidSheet({required int index, required List<int> days}) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _ShareValidView(index: index, days: days);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}


class _ShareValidView extends StatefulWidget {
  final int index;
  final List<int> days;
  const _ShareValidView({required this.index, required this.days});

  @override
  State<_ShareValidView> createState() => _ShareValidViewState();
}

class _ShareValidViewState extends BaseXState<_ShareValidLogic, _ShareValidView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 303.w + safeAreaBottom,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: 20.radius),
          color: kWhite()
      ),
      padding: EdgeInsets.all(16.w),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                pop(context: context);
              },
              child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText('设置分享有效期', color: k3(), size: 18.sp,)
                  ],
                ),
                spaceH(15),
                ListView.separated(
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        pop(context: context,args: index);
                      },
                      child: Container(
                        width: 327.w,
                        height: 51.w,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      widget.days[index] == -1 ? Text.rich(TextSpan(
                                          children: [
                                            TextSpan(text: '永久',style: TextStyle(color: k4A83FF(),fontSize: 13.sp,fontWeight: FontWeight.w600)),
                                            TextSpan(text: '有效',style: TextStyle(color: k3(),fontSize: 13.sp,fontWeight: FontWeight.w600)),
                                          ]
                                      )) : Text.rich(TextSpan(
                                          children: [
                                            TextSpan(text: '${widget.days[index]}',style: TextStyle(color: k4A83FF(),fontSize: 13.sp,fontWeight: FontWeight.w600)),
                                            TextSpan(text: '天有效',style: TextStyle(color: k3(),fontSize: 13.sp,fontWeight: FontWeight.w600)),
                                          ]
                                      ))
                                    ],
                                  ),
                                  spaceH(3),
                                  widget.days[index] == -1 ? MyText('分享后永久有效',color: k9(),size: 10.sp,) : MyText('分享后${widget.days[index]}天失效，无法继续访问',color: k9(),size: 10.sp,)
                                ],
                              ),
                            ),
                            CheckView(size: 14.w,selected: widget.index == index)
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context,index){
                    return spaceH(5);
                  },
                  itemCount: widget.days.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  _ShareValidLogic get initController => _ShareValidLogic();
}

class _ShareValidLogic extends BaseLogic {
  // final int day;
  // final days = [1,7,30,180];

  // _ShareValidLogic(this.day);

}
