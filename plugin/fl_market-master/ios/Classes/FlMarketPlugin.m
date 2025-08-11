#import "FlMarketPlugin.h"

@implementation FlMarketPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fl_market"
            binaryMessenger:[registrar messenger]];
  FlMarketPlugin* instance = [[FlMarketPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"startMarket" isEqualToString:call.method]){
      NSString* urlStr = [[NSString alloc] initWithFormat:@"itms-apps://itunes.apple.com/app/id%@",call.arguments[@"iOSAppId"]];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
