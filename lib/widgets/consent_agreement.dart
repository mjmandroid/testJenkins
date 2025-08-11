import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ConsentAgreement extends StatefulWidget {

  final bool consentAgreement;
  final bool autoRenew;
  final GestureTapCallback onTap;

  const ConsentAgreement({ required this.consentAgreement, required this.onTap, this.autoRenew = true, super.key});

  @override
  State<ConsentAgreement> createState() => _ConsentAgreementState();
}

class _ConsentAgreementState extends State<ConsentAgreement> {
  @override
  Widget build(BuildContext context) {
    return MyInkWell(
      onTap: widget.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [                          
          Image.asset(
            widget.consentAgreement ? R.assetsCheckAutoRenewalY : R.assetsCheckSquareN,
            width: 18.w,
            height: 18.w,
          ),
          spaceW(3),
          Text.rich(
            TextSpan(
              text: '请阅读并同意',
              style: TextStyle(
                color: k9(),
                fontSize: 10.sp
              ),
              children: [
                TextSpan(
                  text: widget.autoRenew ? ' 续费协议' : '',
                  style: TextStyle(
                    color: k6(),
                    fontSize: 10.sp
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    push(MyRouter.webView, args: {'title': '续费协议', 'url': user.appInitData.value!.agreement!.renew});
                  }
                ),
                TextSpan(
                  text: widget.autoRenew ? ' | ' : '',
                  style: TextStyle(
                    color: k6(),
                    fontSize: 10.sp
                  )
                ),
                TextSpan(
                  text: ' 用户协议',
                  style: TextStyle(
                    color: k6(),
                    fontSize: 10.sp
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    push(MyRouter.webView, args: {'title': '用户协议', 'url': user.appInitData.value!.agreement!.reg});
                  }
                )
              ]
            )
          ),
        ],
      ),
    );
  }
}