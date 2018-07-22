#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AthleteMO;

@interface DataController : NSObject

// Core Data stack properties
@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
@property (strong, nonatomic) AthleteMO *currentAthlete;

+ (DataController *)sharedInstance;

- (void)saveContext;
- (void)deleteStore;

@end
