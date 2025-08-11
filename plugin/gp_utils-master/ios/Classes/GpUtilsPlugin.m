#import "GpUtilsPlugin.h"
#if __has_include(<gp_utils/gp_utils-Swift.h>)
#import <gp_utils/gp_utils-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gp_utils-Swift.h"
#endif

@implementation GpUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGpUtilsPlugin registerWithRegistrar:registrar];
}
@end
