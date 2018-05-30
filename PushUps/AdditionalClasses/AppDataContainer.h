#import <Foundation/Foundation.h>

@interface AppDataContainer : NSObject

@property (copy, nonatomic) NSString *senderSegueIdentifier;

+ (AppDataContainer *)sharedInstance;

@end
