#import "AppDataContainer.h"

@implementation AppDataContainer

+ (AppDataContainer *)sharedInstance {
    static AppDataContainer *sharedInstance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        NSLog(@"%s - creating AppDataContainer", __func__);
        sharedInstance = [[AppDataContainer alloc] init];
    });
    
    return sharedInstance;
}

@end
