import 'dart:convert';

import 'package:desk_cloud/r.dart';
import 'package:desk_cloud/utils/extension.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/pointycastle.dart';

class SignUtil {

  // Rsa加密最大长度(密钥长度/8-11)
  static const int MAX_ENCRYPT_BLOCK = 245;

  // Rsa解密最大长度(密钥长度/8)
  static const int MAX_DECRYPT_BLOCK = 256;

  static Future<String> sign(Map body,int timestamp,String rsa)async{
    final map = Map.from(body);
    map['api-time'] = timestamp;
    var keys = map.keys.toList();
    keys.sort();
    var str = '';
    for (var value in keys) {
      if (str.isNotEmpty){
        str += '&';
      }
      str += '$value=${map[value]}';
    }
    debugPrint(str);
    // if (AppConfig.beta) {
    //   str += '&key=$rsa';
    // }else{
    //   str += '&key=Sru22*7f7F!fGG';
    // }
    str += '&key=Sru22*7f7F!fGG';
    debugPrint(str);
    final sign = str.toMd5.toUpperCase();
    debugPrint('sign=$sign');
    return sign;
  }

  // //公钥分段加密
  // static Future encodeString(String content) async {
  //   final publicPem = await rootBundle.loadString(R.assetsOtherTestEnPub);
  //   //创建公钥对象
  //   RSAPublicKey publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
  //   //创建加密器
  //   final encrypter = Encrypter(RSA(publicKey: publicKey));

  //   //分段加密
  //   // 原始字符串转成字节数组
  //   List<int> sourceBytes = utf8.encode(content);
  //   //数据长度
  //   int inputLength = sourceBytes.length;
  //   // 缓存数组
  //   List<int> cache = [];
  //   // 分段加密 步长为MAX_ENCRYPT_BLOCK
  //   for(int i=0;i<inputLength;i+=MAX_ENCRYPT_BLOCK){
  //     //剩余长度
  //     int endLen = inputLength-i;
  //     List<int> item;
  //     if(endLen > MAX_ENCRYPT_BLOCK){
  //       item = sourceBytes.sublist(i,i+MAX_ENCRYPT_BLOCK);
  //     }else {
  //       item = sourceBytes.sublist(i,i+endLen);
  //     }
  //     // 加密后对象转换成数组存放到缓存
  //     cache.addAll(encrypter.encryptBytes(item).bytes);
  //   }
  //   return base64Encode(cache);
  //   // //创建加密器
  //   // final encrypter = Encrypter(RSA(publicKey: publicKey));
  //   //
  //   // return encrypter.encrypt(content).base64;
  // }

  // //公钥分段解密
  // static Future decodeString(String content) async{
  //   final privatePem = await rootBundle.loadString(R.assetsOtherTestEnvPri);
  //   //创建公钥对象
  //   RSAPrivateKey privateKey = RSAKeyParser().parse(privatePem) as RSAPrivateKey;

  //   AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine());
  //   cipher.init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

  //   //分段解密
  //   //原始数据
  //   List<int> sourceBytes = base64Decode(content);
  //   //数据长度
  //   int inputLength = sourceBytes.length;
  //   // 缓存数组
  //   List<int> cache = [];
  //   // 分段解密 步长为MAX_DECRYPT_BLOCK
  //   for(var i=0;i<inputLength;i+=MAX_DECRYPT_BLOCK){
  //     //剩余长度
  //     int endLen =inputLength - i;
  //     List<int> item;
  //     if(endLen > MAX_DECRYPT_BLOCK){
  //       item = sourceBytes.sublist(i,i+MAX_DECRYPT_BLOCK);
  //     }else {
  //       item = sourceBytes.sublist(i,i+endLen);
  //     }
  //     //解密后放到数组缓存
  //     cache.addAll(cipher.process(Uint8List.fromList(item)));
  //   }
  //   return utf8.decode(cache);


  // }

  //公钥分段加密
  static Future<String> encodeString(String content) async {
    debugPrint(content);
    final publicPem = await rootBundle.loadString(R.assetsOtherTestEnPub);
    RSAPublicKey publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    List<String> encryptedParts = [];
    List<int> contentBytes = utf8.encode(content);
    int length = contentBytes.length;

    for (int i = 0; i < length; i += MAX_ENCRYPT_BLOCK) {
      int endIndex = (i + MAX_ENCRYPT_BLOCK > length) ? length : i + MAX_ENCRYPT_BLOCK;
      List<int> segmentBytes = contentBytes.sublist(i, endIndex);
      final encryptedSegment = encrypter.encryptBytes(segmentBytes).base64;
      encryptedParts.add(encryptedSegment);
    }

    return encryptedParts.join('|');
  }
  
  //公钥分段解密
  static Future decodeString(String content) async{
    List<String> tempArr = content.split('|');
    //加载公钥字符串
    final publicPem = await rootBundle.loadString(R.assetsOtherTestEnPub);
    //创建公钥对象
    RSAPublicKey publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;

    AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine());
    cipher.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

    // 缓存数组
    List<int> cache = [];
    for (var item in tempArr) {
      //分段解密
      //原始数据
      List<int> sourceBytes = base64Decode(item);
      //数据长度
      int inputLength = sourceBytes.length;
      // 分段解密 步长为MAX_DECRYPT_BLOCK
      for(var i=0;i<inputLength;i+=MAX_DECRYPT_BLOCK){
        //剩余长度
        int endLen =inputLength - i;
        List<int> item;
        if(endLen > MAX_DECRYPT_BLOCK){
          item = sourceBytes.sublist(i,i+MAX_DECRYPT_BLOCK);
        }else {
          item = sourceBytes.sublist(i,i+endLen);
        }
        //解密后放到数组缓存
        cache.addAll(cipher.process(Uint8List.fromList(item)));
      }
    }
    debugPrint(utf8.decode(cache));
    return utf8.decode(cache);
  }


  // 私钥分段解密
  static Future<String> decodeWithPrivateKey(String content) async {
    // 加载私钥字符串
    final privatePem = await rootBundle.loadString(R.assetsOtherTestEnvPri);
    final privateKey = RSAKeyParser().parse(privatePem) as RSAPrivateKey;

    // 使用 PKCS1 解码器
    final cipher = PKCS1Encoding(RSAEngine());
    cipher.init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    // 逐段解密
    List<String> encryptedParts = content.split('|');
    List<int> decryptedBytes = [];

    for (var part in encryptedParts) {
      // 解码每个分段
      List<int> sourceBytes = base64Decode(part);
      int inputLength = sourceBytes.length;

      // 分段解密
      for (int i = 0; i < inputLength; i += MAX_DECRYPT_BLOCK) {
        int end = (i + MAX_DECRYPT_BLOCK > inputLength) ? inputLength : i + MAX_DECRYPT_BLOCK;
        Uint8List sublist = Uint8List.fromList(sourceBytes.sublist(i, end));
        
        // 解密该段并追加到结果
        decryptedBytes.addAll(cipher.process(sublist));
      }
    }

    print(utf8.decode(decryptedBytes));

    // 返回解密后的字符串
    return utf8.decode(decryptedBytes);
  }

}