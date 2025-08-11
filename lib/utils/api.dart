import 'package:desk_cloud/content/user/user_logic.dart';
import 'package:sp_util/sp_util.dart';

class SP {
  SP._init();

  static bool get hasDebug =>
      SpUtil.getBool("hasDebug", defValue: false) ?? false;
  static set hasDebug(bool? value) =>
      SpUtil.putBool("hasDebug", value ?? false);

  static bool get isAgreement =>
      SpUtil.getBool("isAgreement", defValue: false) ?? false;
  static set isAgreement(bool? value) =>
      SpUtil.putBool("isAgreement", value ?? false);

  static int get hostType => SpUtil.getInt("hostType", defValue: 0) ?? 0;
  static set hostType(int value) => SpUtil.putInt("hostType", value);

  static bool get photoPermissionRequested =>
      SpUtil.getBool("photoPermissionRequested", defValue: false) ?? false;
  static set photoPermissionRequested(bool? value) =>
      SpUtil.putBool("photoPermissionRequested", value ?? false);

  /// 记录获取的权限数据，这是一个JSON字符串
  static String get permissionStr =>
      SpUtil.getString("permissionStr", defValue: '') ?? '';
  static set permissionStr(String? value) =>
      SpUtil.putString("permissionStr", value ?? '');

  static String get debugProxy =>
      SpUtil.getString("debugProxy", defValue: '') ?? '';
  static set debugProxy(String? value) =>
      SpUtil.putString("debugProxy", value ?? '');

  //自定义测试地址
  static String get userApiUrl =>
      SpUtil.getString("userApiUrl", defValue: '') ?? '';
  static set userApiUrl(String? value) =>
      SpUtil.putString("userApiUrl", value ?? '');

  static String get token => SpUtil.getString("token", defValue: '') ?? '';
  static set token(String? value) => SpUtil.putString("token", value ?? '');

  static int get limitedTimeOfferTimestamp =>
      SpUtil.getInt("limitedTimeOfferTimestamp_${user.memberEquity.value?.id}",
          defValue: 0) ??
      0;
  static set limitedTimeOfferTimestamp(int? value) => SpUtil.putInt(
      "limitedTimeOfferTimestamp_${user.memberEquity.value?.id}", value ?? 0);

  static List<String> get searchRecord =>
      SpUtil.getStringList('user_${user.memberEquity.value?.id}_searchRecord',
          defValue: []) ??
      [];
  static set searchRecord(List<String>? value) => SpUtil.putStringList(
      'user_${user.memberEquity.value?.id}_searchRecord', value ?? []);

  static int get initOssTime => SpUtil.getInt("initOssTime", defValue: 0) ?? 0;
  static set initOssTime(int? value) =>
      SpUtil.putInt("initOssTime", value ?? 0);

  static bool get smsNotice =>
      SpUtil.getBool("smsNotice", defValue: true) ?? true;
  static set smsNotice(bool? value) =>
      SpUtil.putBool("smsNotice", value ?? true);

  static bool get interestNotice =>
      SpUtil.getBool("interestNotice", defValue: true) ?? true;
  static set interestNotice(bool? value) =>
      SpUtil.putBool("interestNotice", value ?? true);

  static List<String> get noticeRecord =>
      SpUtil.getStringList('user_${user.memberEquity.value?.id}_noticeRecord',
          defValue: []) ??
      [];
  static set noticeRecord(List<String>? value) => SpUtil.putStringList(
      'user_${user.memberEquity.value?.id}_noticeRecord', value ?? []);

  static String get coolDown => SpUtil.getString("coolDownTime",defValue: "") ?? "";
  static set coolDown(String value) => SpUtil.putString("coolDownTime",value);
}

class Api {
  //用于控制生命周期类各个弹框只弹出一次
  static Map<String, int> alertMap = {};

  Api._init();

  // static get host => beta ? testHost : producedHost;

  // static const String producedHost = "https://api.diskyun.com";

  // static const needRsa = false;

  // static String get testHost => ["http://api.diskyun.com", "https://api.diskyun.com",SP.userApiUrl][SP.hostType];

  // static bool beta = false; //Android 通过gradle中的isDebug控制 iOS通过info中的app_debug控制 此处只是挂名

  ///用户登录/注册 mobile sms_code
  static const login = '/index/login';

  ///发送短信 mobile scene ///发送场景:login=注册/登录验证码,change_mobile=换绑手机号
  static const sendSms = '/index/send_sms';

  ///一键登录  access_token  bussiness服务商类型:固定为1
  static const loginFast = '/index/login_fast';

  ///初始化参数
  static const common = '/index/common';

  ///获取会员商品列表
  static const getProducts = '/user/get_products';

  ///获取会员权益
  static const getUserVip = '/user/get_vip';

  ///提取日志
  static const diskCodeLogs = '/disk_code/logs';

  ///查询口令
  static const diskCodeViews = '/disk_code/views';

  ///提取文件(转存)
  static const diskCodeSave = '/disk_code/save';

  ///检查登录
  static const checkLogin = '/index/check_login';

  ///文件夹列表
  static const dirList = '/disk/dir_list';

  ///创建文件夹
  static const addDir = '/disk/add_dir';

  ///修改昵称
  static const userEditInfo = '/user/edit_info';

  ///文件列表
  static const diskIndex = '/disk/index';

  ///文件详情
  static const diskDetail = '/disk/detail';

  ///更换手机号
  static const userChangeMobile = '/user/change_mobile';

  /// 自动续费列表
  static const autoRenewalOrderList = '/user_orders/order_list';

  /// 立减金额
  static const instantReduction = '/user/productDiscount';

  /// 关闭自动续费
  static const closeAutoRenewal = '/user_orders/close_renew';

  /// 注销账号
  static const userCancel = '/user/cancel';

  /// 检查版本
  static const checkAppVersion = '/index/version';

  ///删除文件(夹)
  static const fileDelete = '/disk/del_file';

  ///创建分享链接
  static const diskCodeCreate = '/disk_code/create';

  ///重命名文件(夹)
  static const renameFile = '/disk/rename_file';

  ///移动文件
  static const diskMove = '/disk/move';

  ///获取回收站列表
  static const getRecycleList = '/recycle/get_list';

  ///还原回收站文件
  static const recycleReduction = '/recycle/reduction';

  ///删除回收站文件
  static const recycleDel = '/recycle/dels';

  ///获取口令码
  static const getShareCode = '/index/get_share_code';

  ///创建订单
  static const orderCreate = '/user_orders/create';

  ///获取支付方式
  static const checkGateway = '/user_orders/check_gateway';

  ///搜索结果
  static const diskSearch = '/disk/search';

  ///搜索初始化参数
  static const diskSearchInit = '/disk/search';

  ///获取分享口令
  static const getCodeList = '/disk_code/get_code_list';

  ///删除分享口令
  static const delCode = '/disk_code/del_code';

  ///sts
  static const stsToken = '/aliyun/sts_token';

  ///上传文件前的检测
  static const preUpload = '/disk/pre_upload';

  ///上报开始任务
  static const startTask = '/disk/start_task';

  ///上报删除任务
  static const delTask = '/disk/del_task';

  ///上报上传文件
  static const uploadTask = '/disk/upload';

  ///会员权益对比
  static const vipPowers = '/v2/user/vip_powers';

  ///上传文件
  static const uploadFile = '/index/upload';

  ///意见反馈
  static const userFeedback = '/user/feedback';

  ///解压缩
  static const aliyunUnzipTask = '/aliyun/unzip_task';

  ///检查文件是否存在
  static const aliyunCheckFile = '/aliyun/check_file';

  ///获取任务进度
  static const aliyunGetTaskDetail = '/aliyun/get_task_detail';

  /// 解压任务列表
  static const transferList = '/transfer/get_list';

  /// 验证IOS支付
  static const verifyIospay = '/user_orders/verify_iospay';

  /// 文件预览（仅支持image、video、pdf）
  static const aliyunGetUrl = '/aliyun/get_url';

  /// 恢复订阅
  static const restoreOrders = '/user_orders/restore_orders';

  /// 文件夹子文件
  static const getDirFiles = '/transfer/get_dir_files';

  /// 获取公告列表
  static const getNoticeList = '/index/notice_dialog';

  /// 获取socketToken
  static const getSocketToken = '/user/get_socket_token';

  ///会员弹窗倒计时
  static const getBulletTime = '/user/bulletFrame';
  /// 获取冷却时间
  static const getCoolDown = '/user/guestCoolDown';
}
