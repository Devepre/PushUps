#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataController : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (DataController *)sharedInstance;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;

@end
