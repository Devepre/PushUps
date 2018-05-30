#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AthleteMO;

@interface DataController : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) AthleteMO *currentAthlete;

+ (DataController *)sharedInstance;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;
- (void)deleteStore;

@end
