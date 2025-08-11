import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:common_utils/common_utils.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/alert/upload_dialog.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/entity/app_version_entity.dart';
import 'package:desk_cloud/utils/api.dart';
import 'package:desk_cloud/utils/app_config.dart';
import 'package:desk_cloud/utils/extension.dart';
import 'package:desk_cloud/utils/my_router.dart';
import 'package:desk_cloud/utils/sign_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
// import 'package:log_show/log_show.dart';
import 'package:package_info/package_info.dart';
import 'package:realm/realm.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:desk_cloud/entity/base_entity.dart';
import 'package:desk_cloud/utils/export.dart' as tempGet;
import 'package:url_launcher/url_launcher.dart';

class ApiNet {
  ApiNet._();

  static Dio? _dio;

  // 添加一个取消令牌管理器
  static final Map<String, CancelToken> _cancelTokens = {};

  /// 创建 dio 实例对象
  static Dio _createInstance() {
    if (_dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        validateStatus: (status) {
          // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
          return true;
        },
      );
      _dio = Dio(options);
      // _dio!.interceptors.add(LogShowInterceptor());
      _dio!.interceptors.add(TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printRequestData: true,
        printResponseHeaders: false,
        printResponseMessage: false,
        printResponseData: true,
      )));
    }
    (_dio?.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      client.findProxy = (uri) {
        return SP.debugProxy.isNotEmpty && AppConfig.beta ? 'PROXY ${SP.debugProxy}' : 'DIRECT';
      };
      return client;
    };
    return _dio!;
  }

  static dynamic _version;

  static Future<Map<String, Object>> getHeader({required int timestamp,required String sign}) async {
    String channel = 'IOS';
    if (Platform.isAndroid) {
      channel = const String.fromEnvironment('CHANNEL', defaultValue: 'default');
    }
    var headers = <String, Object>{};
    headers['api-version'] = _version ??= (await PackageInfo.fromPlatform()).version;
    headers['api-token'] = SP.token;
    headers['api-time'] = timestamp;
    headers['api-sign'] = sign;
    headers['api-platform'] = Platform.isAndroid ? 'android' : 'ios';
    headers['channel'] = channel;
    return headers;
  }


  static Future<Response> _request(
    String path, {
    data,
    String method = "post",
    ResponseType? type,
    CancelToken? cancelToken,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch~/1000;
      final rsa = await SignUtil.encodeString(jsonEncode(data ?? {}));
      // debugPrint('rsa=$rsa');
      // final rsaDecode = await SignUtil.decodeString(rsa);
      // debugPrint('rsaDecode=$rsaDecode');
      final sign = await SignUtil.sign(data ?? {}, timestamp,rsa);
      var headers = await getHeader(sign: sign,timestamp: timestamp);
      print(headers);
      path = path.toApiUrl();
      Options options = Options(headers: headers, method: method, responseType: type);
      Dio dio = _createInstance();
      Response response;
      if (method == "post") {
        response = await dio.request(
          path,
          // data: Api.needRsa ? rsa : data,
          data: AppConfig.needRsa ? rsa : data,
          options: options,
          cancelToken: cancelToken,
        );
      } else {
        response = await dio.request(
          path,
          queryParameters: data,
          // queryParameters: AppConfig.needRsa ? rsa : data,
          data: AppConfig.needRsa ? rsa : data,
          options: options,
          cancelToken: cancelToken,
        );
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
          throw MyException('网络超时，请稍后重试！', code: 5001);
        } else if (e.type == DioExceptionType.connectionError) {
          throw MyException('请求失败，请稍后重试！', code: 5002);
        } else if (e.type == DioExceptionType.cancel) {
          throw MyException('取消已请求！', code: 5003);
        } else if (e.type == DioExceptionType.badCertificate) {
          throw MyException('证书无效！', code: 5004);
        } else if (e.type == DioExceptionType.badResponse) {
          throw MyException('请求失败，请稍后重试！', code: 5005);
        } else {
          if (e.error != null && e.error is SocketException) {
            throw MyException('无连接网络', code: 5008);
          }
          throw MyException('未知错误', code: 5006);
        }
      } else {
        throw MyException("哎呀，网络开小差了～", code: 5007);
      }
    }
  }

  static Future<BaseEntity<T>> request<T>(String url, {Map<String, dynamic>? data, String method = "post", bool needParse = true, bool skipLogin = false}) async {
    // 为每个请求创建一个新的取消令牌
    final cancelToken = CancelToken();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    _cancelTokens[requestId] = cancelToken;

    try {
      data ??= {};
      data['randomString'] = generateRandomString(16);
      Response response = await _request(url, data: data, method: method);
      var result = response.data;
      // if (Api.needRsa){
      if (AppConfig.needRsa){
        result = await SignUtil.decodeString(result);
      }
      if (response.statusCode == 401 && needParse) {
        throw Exception("token已过期或者未授权");
      } else if (response.statusCode == 105 && needParse) {
        showOpenMemberSheet();
        throw MyException("需要升级会员");
      } else if (response.statusCode != 200 && needParse) {
        throw Exception("网络请求错误 code=${response.statusCode}");
      } else {
        BaseEntity<T>? baseEntity;
        if (!needParse) {
          baseEntity = BaseEntity<T>();
          baseEntity.data = result;
          return baseEntity;
        }
        if (result is String) {
          baseEntity = JsonUtil.getObj(result, (v) => BaseEntity<T>.fromJson(Map.from(v)));
        } else {
          baseEntity = BaseEntity<T>.fromJson(Map.from(result));
        }
        /// 2024.09.12 Xie修改
        // if (baseEntity?.code == 200 || baseEntity?.code == 0) {
        if (baseEntity?.code == 200 || baseEntity?.code == 990) {
          // 当收到 990 响应码时，取消所有其他请求
          if (baseEntity?.code == 990) {
            dismissLoading();
            cancelAllRequests('收到990响应码，取消所有请求');
            late AppVersionEntity appVersionEntity;
            if (result is String) {
              // 解析字符串格式的响应数据
              final Map<String, dynamic> jsonMap = jsonDecode(result);
              appVersionEntity = AppVersionEntity.fromJson(jsonMap['data']);
            } else {
              // 解析 Map 格式的响应数据
              appVersionEntity = AppVersionEntity.fromJson((result as Map<String, dynamic>)['data']);
            }
            var res = await showUploadDialog(
              message: appVersionEntity.content,
              dismissible: false,
              enforce: appVersionEntity.enforce ?? 0,
              onValueChanged: (res) async {
                final Uri uri = Uri.parse(appVersionEntity.downloadurl ?? '');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication
                  );
                }
              }
            );
            if (res == null || !res) {
              if (appVersionEntity.enforce == 1) {
                // 确保所有资源都被正确释放
                await Future.delayed(const Duration(milliseconds: 100));
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              }
            }
          }
          return baseEntity ?? BaseEntity();
        }
        // if (baseEntity?.code == -996 || baseEntity?.code == -998) {
        //   userC.logout();
        //   dismissLoading();
        //   if (!skipLogin) {
        //     CommonUse().gotoLoginPage();
        //     throw "请登录";
        //   }
        // }
        if (baseEntity?.code == 999) {
          //版本需要更新
          throw MyException("有新版本，请更新", code: 999, data: baseEntity?.data);
        }
        if (baseEntity?.code == 105) {
          final Map<String, dynamic> map = result is String 
              ? jsonDecode(result) 
              : Map<String, dynamic>.from(result);
              
          final data = map['data'] as Map<String, dynamic>;
          final title = data['title'] as String;
          final subtitle = data['subtitle'] as String;
          
          showOpenMemberSheet(title: title, subTitle: subtitle);
          throw MyException(baseEntity?.msg ?? '');
        }
        if (baseEntity?.code == 980) {

          if (tempGet.Get.isRegistered<TabIoLogic>()) {
            ioLogic.unzipTimer?.cancel();
          }

          oss.downloadTaskList.value.query(r'status == 1 || status == 2 || status == 0 || status == 5').forEach((element) {
            oss.cancelTask(element);
          });

          oss.uploadTaskList.value.query(r'status == 1 || status == 2 || status == 0 || status == 5').forEach((element) {
            oss.cancelTask(element);
          });
          tabParentLogic.productController?.dispose();
          tabParentLogic.productController = null;
          tabParentLogic.productAnimation = null;

          SP.token = '';
          pushAndRemove(MyRouter.mobileLogin);
        }
        throw MyException(baseEntity?.msg ?? '', code: baseEntity?.code, data: baseEntity?.data);
      }
    } catch (e) {
      rethrow;
    } finally {
      _cancelTokens.remove(requestId);
    }
  }

  static Future<dynamic> requestFullUrl(String url, {Map<String, dynamic>? parameters, String method = 'get'}) async {
    try {
      Dio dio = _createInstance();
      Response response;
      if (url.startsWith("http")) {
        dio.options.baseUrl = "";
      } else {
        // dio.options.baseUrl = Api.host;
        dio.options.baseUrl = AppConfig.apiHost;
      }
      if (method == "post") {
        response = await dio.request(
          url,
          data: parameters,
          options: Options(method: method),
        );
      } else {
        response = await dio.request(
          url,
          queryParameters: parameters,
          options: Options(method: method),
        );
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<BaseEntity> uploadFile<T>(String url, File file, {String method = "post", bool needParse = true, bool skipLogin = false}) async {
    // final file = await assetEntity.file;
    MultipartFile mf = await MultipartFile.fromFile(file.path);
    var path = url.toApiUrl();
    Dio dio = _createInstance();
    final timestamp = DateTime.now().millisecondsSinceEpoch~/1000;
    final rsa = await SignUtil.encodeString(jsonEncode({}));
    // debugPrint('rsa=$rsa');
    // final rsaDecode = await SignUtil.decodeString(rsa);
    // debugPrint('rsaDecode=$rsaDecode');
    final sign = await SignUtil.sign({}, timestamp, rsa);
    var headers = await getHeader(sign: sign,timestamp: timestamp);
    Options options = Options(headers: headers, method: method);
    try {
      Response response = await dio.request(
        path,
        data: FormData.fromMap({'file': mf}),
        options: options
      );
      var result = response.data;
      // if (Api.needRsa){
      if (AppConfig.needRsa){
        result = await SignUtil.decodeString(result);
      }
      if (response.statusCode == 401 && needParse) {
        throw Exception("token已过期或者未授权");
      } else if (response.statusCode != 200 && needParse) {
        throw Exception("网络请求错误 code=${response.statusCode}");
      } else {
        BaseEntity<T>? baseEntity;
        if (!needParse) {
          baseEntity = BaseEntity<T>();
          baseEntity.data = result;
          return baseEntity;
        }
        if (result is String) {
          baseEntity = JsonUtil.getObj(result, (v) => BaseEntity<T>.fromJson(Map.from(v)));
        } else {
          baseEntity = BaseEntity<T>.fromJson(Map.from(result));
        }
        /// 2024.09.12 Xie修改
        // if (baseEntity?.code == 200 || baseEntity?.code == 0) {
        if (baseEntity?.code == 200) {
          return baseEntity ?? BaseEntity();
        }
        // if (baseEntity?.code == -996 || baseEntity?.code == -998) {
        //   userC.logout();
        //   dismissLoading();
        //   if (!skipLogin) {
        //     CommonUse().gotoLoginPage();
        //     throw "请登录";
        //   }
        // }
        if (baseEntity?.code == 999) {
          //版本需要更新
          throw MyException("有新版本，请更新", code: 999, data: baseEntity?.data);
        }
        throw MyException(baseEntity?.msg ?? '', code: baseEntity?.code, data: baseEntity?.data);
      }
    } catch (e) {
      rethrow;
    }
  }
  /// 生成指定长度的随机字符串
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// 取消所有请求
  static void cancelAllRequests([String? reason]) {
    _cancelTokens.forEach((key, token) {
      if (!token.isCancelled) {
        token.cancel(reason);
      }
    });
    _cancelTokens.clear();
  }

}

class MyException implements Exception {
  final String message;
  final int? code;
  final dynamic data;

  MyException(this.message, {this.code, this.data});

  @override
  String toString() {
    return message;
  }
}
