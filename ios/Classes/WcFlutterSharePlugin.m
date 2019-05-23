#import "WcFlutterSharePlugin.h"
#import <wc_flutter_share/wc_flutter_share-Swift.h>

@implementation WcFlutterSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWcFlutterSharePlugin registerWithRegistrar:registrar];
}
@end
