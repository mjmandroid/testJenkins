import 'package:desk_cloud/utils/multi_app_config.dart';

dynamic get buyLink {
  return {
    'title':'购买协议',
    'url': "https://ph5.kawakw.com/caishenka/agreement/newPrivacy.html?appName=${MultiAppConfig.buyLink}&path=Educate"
  };
}

dynamic get renewLink {
  return {
    'title':'自动续费协议',
    'url': "https://ph5.kawakw.com/caishenka/agreement/newPrivacy.html?appName=${MultiAppConfig.renewLink}&path=Educate"
  };
}

dynamic get privacyLink {
  return {
    'title':'隐私协议',
    'url': "https://ph5.kawakw.com/caishenka/agreement/newPrivacy.html?appName=${MultiAppConfig.privacyLink}&path=Educate"
  };
}

dynamic get memberLink {
  return {
    'title':'会员服务协议',
    'url': "https://ph5.kawakw.com/caishenka/agreement/newPrivacy.html?appName=${MultiAppConfig.memberLink}&path=Educate"
  };
}

dynamic get userLink {
  return {
    'title':'用户服务协议',
    'url': "https://ph5.kawakw.com/caishenka/agreement/newPrivacy.html?appName=${MultiAppConfig.userLink}&path=Educate"
  };
}

dynamic get createLink {
  return {
    'title':'创作规范',
    'url': "https://ph5.kawakw.com/caishenka/agreement/newPrivacy.html?appName=${MultiAppConfig.createLink}&path=Educate"
  };
}