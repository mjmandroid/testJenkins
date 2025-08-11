import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/app_init_entity.dart';

AppInitEntity $AppInitEntityFromJson(Map<String, dynamic> json) {
  final AppInitEntity appInitEntity = AppInitEntity();
  final AppInitAgreement? agreement = jsonConvert.convert<AppInitAgreement>(
      json['agreement']);
  if (agreement != null) {
    appInitEntity.agreement = agreement;
  }
  final List<String>? advImg = (json['adv_img'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (advImg != null) {
    appInitEntity.advImg = advImg;
  }
  final AppInitAbout? about = jsonConvert.convert<AppInitAbout>(json['about']);
  if (about != null) {
    appInitEntity.about = about;
  }
  final AppInitShareParams? shareParams = jsonConvert.convert<
      AppInitShareParams>(json['share_params']);
  if (shareParams != null) {
    appInitEntity.shareParams = shareParams;
  }
  final List<String>? version = (json['version'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (version != null) {
    appInitEntity.version = version;
  }
  final String? ossDomain = jsonConvert.convert<String>(json['oss_domain']);
  if (ossDomain != null) {
    appInitEntity.ossDomain = ossDomain;
  }
  final AppInitWebview? webview = jsonConvert.convert<AppInitWebview>(
      json['webview']);
  if (webview != null) {
    appInitEntity.webview = webview;
  }
  return appInitEntity;
}

Map<String, dynamic> $AppInitEntityToJson(AppInitEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['agreement'] = entity.agreement?.toJson();
  data['adv_img'] = entity.advImg;
  data['about'] = entity.about?.toJson();
  data['share_params'] = entity.shareParams?.toJson();
  data['version'] = entity.version;
  data['oss_domain'] = entity.ossDomain;
  data['webview'] = entity.webview?.toJson();
  return data;
}

extension AppInitEntityExtension on AppInitEntity {
  AppInitEntity copyWith({
    AppInitAgreement? agreement,
    List<String>? advImg,
    AppInitAbout? about,
    AppInitShareParams? shareParams,
    List<String>? version,
    String? ossDomain,
    AppInitWebview? webview,
  }) {
    return AppInitEntity()
      ..agreement = agreement ?? this.agreement
      ..advImg = advImg ?? this.advImg
      ..about = about ?? this.about
      ..shareParams = shareParams ?? this.shareParams
      ..version = version ?? this.version
      ..ossDomain = ossDomain ?? this.ossDomain
      ..webview = webview ?? this.webview;
  }
}

AppInitAgreement $AppInitAgreementFromJson(Map<String, dynamic> json) {
  final AppInitAgreement appInitAgreement = AppInitAgreement();
  final String? privacy = jsonConvert.convert<String>(json['privacy']);
  if (privacy != null) {
    appInitAgreement.privacy = privacy;
  }
  final String? reg = jsonConvert.convert<String>(json['reg']);
  if (reg != null) {
    appInitAgreement.reg = reg;
  }
  final String? renew = jsonConvert.convert<String>(json['renew']);
  if (renew != null) {
    appInitAgreement.renew = renew;
  }
  final String? cancel = jsonConvert.convert<String>(json['cancel']);
  if (cancel != null) {
    appInitAgreement.cancel = cancel;
  }
  final String? service = jsonConvert.convert<String>(json['service']);
  if (service != null) {
    appInitAgreement.service = service;
  }
  return appInitAgreement;
}

Map<String, dynamic> $AppInitAgreementToJson(AppInitAgreement entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['privacy'] = entity.privacy;
  data['reg'] = entity.reg;
  data['renew'] = entity.renew;
  data['cancel'] = entity.cancel;
  data['service'] = entity.service;
  return data;
}

extension AppInitAgreementExtension on AppInitAgreement {
  AppInitAgreement copyWith({
    String? privacy,
    String? reg,
    String? renew,
    String? cancel,
    String? service,
  }) {
    return AppInitAgreement()
      ..privacy = privacy ?? this.privacy
      ..reg = reg ?? this.reg
      ..renew = renew ?? this.renew
      ..cancel = cancel ?? this.cancel
      ..service = service ?? this.service;
  }
}

AppInitAbout $AppInitAboutFromJson(Map<String, dynamic> json) {
  final AppInitAbout appInitAbout = AppInitAbout();
  final String? beian = jsonConvert.convert<String>(json['beian']);
  if (beian != null) {
    appInitAbout.beian = beian;
  }
  final String? beianLink = jsonConvert.convert<String>(json['beian_link']);
  if (beianLink != null) {
    appInitAbout.beianLink = beianLink;
  }
  final String? servicePhone = jsonConvert.convert<String>(
      json['service_phone']);
  if (servicePhone != null) {
    appInitAbout.servicePhone = servicePhone;
  }
  final String? serviceEmail = jsonConvert.convert<String>(
      json['service_email']);
  if (serviceEmail != null) {
    appInitAbout.serviceEmail = serviceEmail;
  }
  return appInitAbout;
}

Map<String, dynamic> $AppInitAboutToJson(AppInitAbout entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['beian'] = entity.beian;
  data['beian_link'] = entity.beianLink;
  data['service_phone'] = entity.servicePhone;
  data['service_email'] = entity.serviceEmail;
  return data;
}

extension AppInitAboutExtension on AppInitAbout {
  AppInitAbout copyWith({
    String? beian,
    String? beianLink,
    String? servicePhone,
    String? serviceEmail,
  }) {
    return AppInitAbout()
      ..beian = beian ?? this.beian
      ..beianLink = beianLink ?? this.beianLink
      ..servicePhone = servicePhone ?? this.servicePhone
      ..serviceEmail = serviceEmail ?? this.serviceEmail;
  }
}

AppInitShareParams $AppInitShareParamsFromJson(Map<String, dynamic> json) {
  final AppInitShareParams appInitShareParams = AppInitShareParams();
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    appInitShareParams.desc = desc;
  }
  final String? logo = jsonConvert.convert<String>(json['logo']);
  if (logo != null) {
    appInitShareParams.logo = logo;
  }
  return appInitShareParams;
}

Map<String, dynamic> $AppInitShareParamsToJson(AppInitShareParams entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['desc'] = entity.desc;
  data['logo'] = entity.logo;
  return data;
}

extension AppInitShareParamsExtension on AppInitShareParams {
  AppInitShareParams copyWith({
    String? desc,
    String? logo,
  }) {
    return AppInitShareParams()
      ..desc = desc ?? this.desc
      ..logo = logo ?? this.logo;
  }
}

AppInitWebview $AppInitWebviewFromJson(Map<String, dynamic> json) {
  final AppInitWebview appInitWebview = AppInitWebview();
  final String? faq = jsonConvert.convert<String>(json['faq']);
  if (faq != null) {
    appInitWebview.faq = faq;
  }
  final AppInitWebviewService? service = jsonConvert.convert<
      AppInitWebviewService>(json['service']);
  if (service != null) {
    appInitWebview.service = service;
  }
  return appInitWebview;
}

Map<String, dynamic> $AppInitWebviewToJson(AppInitWebview entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['faq'] = entity.faq;
  data['service'] = entity.service?.toJson();
  return data;
}

extension AppInitWebviewExtension on AppInitWebview {
  AppInitWebview copyWith({
    String? faq,
    AppInitWebviewService? service,
  }) {
    return AppInitWebview()
      ..faq = faq ?? this.faq
      ..service = service ?? this.service;
  }
}

AppInitWebviewService $AppInitWebviewServiceFromJson(
    Map<String, dynamic> json) {
  final AppInitWebviewService appInitWebviewService = AppInitWebviewService();
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    appInitWebviewService.type = type;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    appInitWebviewService.url = url;
  }
  final String? cid = jsonConvert.convert<String>(json['cid']);
  if (cid != null) {
    appInitWebviewService.cid = cid;
  }
  return appInitWebviewService;
}

Map<String, dynamic> $AppInitWebviewServiceToJson(
    AppInitWebviewService entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['type'] = entity.type;
  data['url'] = entity.url;
  data['cid'] = entity.cid;
  return data;
}

extension AppInitWebviewServiceExtension on AppInitWebviewService {
  AppInitWebviewService copyWith({
    int? type,
    String? url,
    String? cid,
  }) {
    return AppInitWebviewService()
      ..type = type ?? this.type
      ..url = url ?? this.url
      ..cid = cid ?? this.cid;
  }
}