import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

void showAgentAnnouncementDialog() {
  Get.dialog(
    AlertDialog(
      title: Text('代理操作规范',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: k3(),
          )),
      content: SizedBox(
        height: Get.height * 0.4,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: k3(),
                height: 1.5,
              ),
              children: [
                _normalSpan(
                    '为保障平台内容合规、维护公共秩序及国家安全，特发布以下内容管理声明和操作规范，请所有合作代理及上传者认真阅读、严格遵守:\n\n'),
                _boldSpan('一、平台性质说明\n'),
                _normalSpan('1、本平台为工具型内容存储与分享服务商，仅提供基础的文件存储、压缩、转存、传输等技术服务；\n'),
                _normalSpan('2、平台不参与用户上传内容的编辑、审核与传播行为，所有上传内容由用户或合作方个人自行负责;\n'),
                _normalSpan(
                    '3、若您作为合作方身份向他人提供使用入口分享渠道或售卖相关权益，须承担相应的内容监督义务。\n\n'),
                TextSpan(children: [
                  _boldSpan('二、内容上传红线（'),
                  _boldRedSpan('严格禁止以下行为'),
                  _boldSpan('):\n'),
                ]),
                _normalSpan('包括但不限于以下类型内容，一经发现'),
                _redSpan('立即删除，情节严重将配合公安机关追责'),
                _normalSpan(':\n'),
                _normalSpan('1、涉及国家政治安全的敏感信息（含涉政、涉恐、涉港澳台等内容);\n'),
                _normalSpan('2、淫秽色情、赌博、诈骗、暴力恐怖、违法集资、虚假广告；\n'),
                _normalSpan('3、含有侵犯他人隐私、版权、肖像权、名誉权等侵权内容；\n'),
                _normalSpan('4、明知违规仍多次分享/售卖同类非法资源的恶意行为。\n\n'),
                _boldSpan('三、合作方责任义务\n'),
                _normalSpan('1、自觉筛查并清理合作方中的非法内容或异常用户上传记录;\n'),
                _normalSpan(
                    '2、任何如出现公安、网信、电信、网警等单位不达的内容删除、追责或备案通知，请配合平台第一时间删除相关内容；\n'),
                _normalSpan('3、禁止诱导用户上传违法内容、利用平台作黑产分发，平台保留终止合作及上报公安机关的权利。\n\n'),
                _boldSpan('四、免责与追责机制\n'),
                _normalSpan(
                    '1、如因合作方未尽内容监管义务，造成平台被举报、约谈、处罚，平台有权依据《中华人民共和国网络安全法》及相关法律规定向用户或合作方追责;\n'),
                _normalSpan('2、如配合整改不及时、态度消极或拒不配合,平台有权单方终止合作，并'),
                _redSpan('永久封禁账户权限'),
                _normalSpan(';\n'),
                _normalSpan(
                    '3、平台已建立敏感内容识别和审计机制，所有违规行为均可溯源定位合作方信息，请勿抱有侥幸心理。\n\n'),
                _boldSpan('五、举报与自查通道\n'),
                _normalSpan(
                    '如您发现所属合作方内存在违规内容或行为，请立即通过以下方式联系平台进行处理（附联系方式或客服邮箱)\n'),
                _boldSpan('举报邮箱：'),
                _boldSpan('admin@diskyun.com\n\n'),
                _boldSpan('特别提醒\n'),
                _redSpan(
                    '一次违规，可能造成用户本人封停、司法调查，请各位用户与合作方切实履行内容审查义务，合规获利，拒绝违法行为。'),
                _normalSpan('本公告即日生效，视为平台与所有用户协议附加条款之一。'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          child: Text(
            '我已阅读并知晓',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: k3(),
            ),
          ),
          onTap: () {
            Get.back();
          },
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

TextSpan _normalSpan(String text) => TextSpan(text: text);
TextSpan _boldSpan(String text) =>
    TextSpan(text: text, style: const TextStyle(fontWeight: FontWeight.bold));
TextSpan _redSpan(String text) =>
    TextSpan(text: text, style: TextStyle(color: kRed()));
TextSpan _boldRedSpan(String text) => TextSpan(
    text: text, style: TextStyle(fontWeight: FontWeight.bold, color: kRed()));
