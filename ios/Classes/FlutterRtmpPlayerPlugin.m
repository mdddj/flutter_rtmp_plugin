#import "FlutterRtmpPlayerPlugin.h"
#if __has_include(<flutter_rtmp_player/flutter_rtmp_player-Swift.h>)
#import <flutter_rtmp_player/flutter_rtmp_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_rtmp_player-Swift.h"
#endif

@implementation FlutterRtmpPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterRtmpPlugin registerWithRegistrar:registrar];
}
@end
