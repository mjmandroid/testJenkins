#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  [GeneratedPluginRegistrant registerWithRegistry:self];

  FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
  FlutterMethodChannel *channel = [FlutterMethodChannel
                                   methodChannelWithName:@"securityScopedAccess"
                                   binaryMessenger:controller.binaryMessenger];

  [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    if ([call.method isEqualToString:@"startAccessing"]) {
      NSString *path = call.arguments[@"path"];
      NSURL *fileURL = [NSURL fileURLWithPath:path];
      
      // 检查是否是 iCloud 文件
      if ([path containsString:@"Mobile Documents/com~apple~CloudDocs"]) {
        NSError *error = nil;
        NSNumber *isDownloaded = nil;
        [fileURL getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemIsDownloadedKey error:&error];
        
        if (!isDownloaded.boolValue) {
          result(@(NO));
          return;
        }
      }

      BOOL success = [fileURL startAccessingSecurityScopedResource];
      result(@(success));
    } 
    else if ([call.method isEqualToString:@"stopAccessing"]) {
      NSString *path = call.arguments[@"path"];
      NSURL *fileURL = [NSURL fileURLWithPath:path];

      [fileURL stopAccessingSecurityScopedResource];
      result(nil);
    } 
    else if ([call.method isEqualToString:@"checkFileDownloaded"]) {
      NSString *path = call.arguments[@"path"];
      NSURL *fileURL = [NSURL fileURLWithPath:path];
      
      // 检查文件是否存在
      if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        result(@(NO));
        return;
      }
      
      // 检查是否是 iCloud 文件
      if ([path containsString:@"Mobile Documents/com~apple~CloudDocs"]) {
        NSError *error = nil;
        NSNumber *isDownloaded = nil;
        NSNumber *isDownloading = nil;
        NSString *downloadStatus = nil;
        
        // 获取多个属性来确认文件状态
        [fileURL getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemIsDownloadedKey error:&error];
        [fileURL getResourceValue:&isDownloading forKey:NSURLUbiquitousItemIsDownloadingKey error:&error];
        [fileURL getResourceValue:&downloadStatus forKey:NSURLUbiquitousItemDownloadingStatusKey error:&error];
        
        // 打印调试信息
        NSLog(@"iCloud file status - path: %@", path);
        NSLog(@"isDownloaded: %@", isDownloaded);
        NSLog(@"isDownloading: %@", isDownloading);
        NSLog(@"downloadStatus: %@", downloadStatus);
        
        // 文件已下载的条件：
        // 1. isDownloaded 为 YES，或
        // 2. downloadStatus 为 "current"，或
        // 3. 文件存在且不在下载中
        BOOL isFileDownloaded = (isDownloaded.boolValue || 
                               [downloadStatus isEqualToString:@"current"] ||
                               (!isDownloading.boolValue && [[NSFileManager defaultManager] fileExistsAtPath:path]));
        
        result(@(isFileDownloaded));
        return;
      }
      
      // 非 iCloud 文件，只要文件存在就返回 true
      result(@(YES));
    }
    else {
      result(FlutterMethodNotImplemented);
    }
  }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end