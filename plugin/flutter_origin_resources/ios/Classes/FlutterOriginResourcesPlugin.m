#import "FlutterOriginResourcesPlugin.h"

@implementation FlutterOriginResourcesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_origin_resources"
            binaryMessenger:[registrar messenger]];
  FlutterOriginResourcesPlugin* instance = [[FlutterOriginResourcesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getResourcePath" isEqualToString:call.method]){
      NSString* name = call.arguments[@"name"];
      if (name == nil){
          result(nil);
          return;
      }
      UIImage* image = [UIImage imageNamed:name];
      if (image == nil){
          image = [UIImage imageWithContentsOfFile:[NSBundle.mainBundle pathForResource:name ofType:@".png"]];
      }
      if (image == nil){
          result(nil);
          return;
      }
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      dispatch_async(queue, ^{
          // 异步执行的代码块
          // 这里可以执行一些耗时的操作，如网络请求、文件读写等
          NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
          NSString *filename = [NSString stringWithFormat:@"%@.png", image];
          NSString *filepath = [cacheDirectory stringByAppendingPathComponent:filename];
          NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
          [imageData writeToFile:filepath atomically:YES];
          dispatch_async(dispatch_get_main_queue(), ^{
              // 回到主线程更新UI等操作
              result(filepath);
          });
      });
    
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
