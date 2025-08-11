import 'dart:math';
import 'package:flutter/material.dart';

final kMainColors = [hexColor('#A647F5'),hexColor('#FF3BAD')];

Color k3([double alpha = 1]){
  return hexColor('#333333',alpha);
}

Color k8D4015([double alpha = 1]){
  return hexColor('#8D4015',alpha);
}


Color k2([double alpha = 1]){
  return hexColor('#222222',alpha);
}

Color kFFDBC2([double alpha = 1]){
  return hexColor('#FFDBC2',alpha);
}

Color kD([double alpha = 1]){
  return hexColor('#DDDDDD',alpha);
}

Color k4([double alpha = 1]){
  return hexColor('#444444',alpha);
}

Color k6([double alpha = 1]){
  return hexColor('#666666',alpha);
}

Color k9([double alpha = 1]){
  return hexColor('#999999',alpha);
}


Color kC([double alpha = 1]){
  return hexColor('#cccccc',alpha);
}

Color kFFECEA([double alpha = 1]){
  return hexColor('#FFECEA',alpha);
}

Color k713801([double alpha = 1]){
  return hexColor('#713801',alpha);
}

Color kE77700([double alpha = 1]){
  return hexColor('#E77700',alpha);
}

Color kFFECDA([double alpha = 1]){
  return hexColor('#FFECDA',alpha);
}

Color k4A83FF([double alpha = 1]){
  return hexColor('#4A83FF',alpha);
}

Color k924B05([double alpha = 1]){
  return hexColor('#924B05',alpha);
}

Color kF5([double alpha = 1]){
  return hexColor('#f5f5f5',alpha);
}

Color kFFBF81([double alpha = 1]){
  return hexColor('#FFBF81',alpha);
}

Color kF87B00([double alpha = 1]){
  return hexColor('#F87B00',alpha);
}

Color kB3([double alpha = 1]){
  return hexColor('#b3b3b3',alpha);
}

Color kB([double alpha = 1]){
  return hexColor('#BBBBBB',alpha);
}

Color kF8([double alpha = 1]){
  return hexColor('#f8f8f8',alpha);
}

Color kFA([double alpha = 1]){
  return hexColor('#fafafa',alpha);
}

Color kWhite([double alpha = 1]){
  return hexColor('#ffffff',alpha);
}

Color kBlack([double alpha = 1]){
  return hexColor('#000000',alpha);
}

Color kRed([double alpha = 1]){
  return hexColor('#ff0000',alpha);
}

Color kBF6502([double alpha = 1]){
  return hexColor('#BF6502',alpha);
}

Color kB66518([double alpha = 1]){
  return hexColor('#B66518',alpha);
}

Color kE([double alpha = 1]){
  return hexColor('#EEEEEE',alpha);
}
Color k2C54AA([double alpha = 1]){
  return hexColor('#2C54AA',alpha);
}
Color kFFCEA0([double alpha = 1]){
  return hexColor('#FFCEA0',alpha);
}
Color kC25E00([double alpha = 1]){
  return hexColor('#C25E00',alpha);
}
Color kF48200([double alpha = 1]){
  return hexColor('#F48200',alpha);
}
Color kFFF5EC([double alpha = 1]){
  return hexColor('#FFF5EC',alpha);
}
Color kEDF3FF([double alpha = 1]){
  return hexColor('#EDF3FF',alpha);
}
Color kBAA998([double alpha = 1]){
  return hexColor('#BAA998',alpha);
}
Color kFFFEF6([double alpha = 1]){
  return hexColor('#FFFEF6',alpha);
}
Color kA34200([double alpha = 1]){
  return hexColor('#A34200',alpha);
}
Color kFF177E([double alpha = 1]){
  return hexColor('#FF177E',alpha);
}
Color kFF7429([double alpha = 1]){
  return hexColor('#FF7429',alpha);
}
Color kFFF6ED([double alpha = 1]){
  return hexColor('#FFF6ED',alpha);
}
Color kFFF3E6([double alpha = 1]){
  return hexColor('#FFF3E6',alpha);
}
Color kFF3867([double alpha = 1]){
  return hexColor('#FF3867',alpha);
}
Color kFFECDD([double alpha = 1]){
  return hexColor('#FFECDD',alpha);
}
Color kFF1413([double alpha = 1]){
  return hexColor('#FF1413',alpha);
}
Color kCDDDFF([double alpha = 1]){
  return hexColor('#CDDDFF',alpha);
}

Color hexColor(String str,[double alpha = 1]) {
  var colorStr = str;
  if (str.startsWith('#')) {
    colorStr = str.replaceAll('#', '');
  }
  var a = min(alpha, 1.0);
  if (colorStr.length == 6) {
    var intColor = int.tryParse('0xff$colorStr');
    return Color(intColor ?? 0xffffffff).withOpacity(a);
  }
  if (colorStr.length == 8) {
    var intColor = int.tryParse('0x$colorStr');
    return Color(intColor ?? 0xffffffff).withOpacity(a);
  }
  return const Color(0xffffffff).withOpacity(a);
}
