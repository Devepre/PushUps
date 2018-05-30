#import "DataController.h"
#import "PushUps+CoreDataModel.h"

@implementation DataController

+ (DataController *)sharedInstance {
    static DataController *sharedInstance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        NSLog(@"%s - creating DataController", __func__);
        sharedInstance = [[DataController alloc] init];
        [sharedInstance initializePersistentContainer];
    });
    
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.persistentContainer.viewContext;
}

#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;

- (void)initializePersistentContainer {
    NSLog(@"%s", __func__);
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PushUps"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSLog(@"%s", __func__);
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)deleteStore {
    NSLog(@"%s", __func__);
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentContainer.persistentStoreCoordinator;
    NSPersistentStore *store = [storeCoordinator.persistentStores firstObject];
    NSError *error;
    [storeCoordinator destroyPersistentStoreAtURL:store.URL
                                         withType:NSSQLiteStoreType
                                          options:nil
                                            error:&error];
    _persistentContainer = nil;
    //ToDo: nillify Singleton correctly
}

#pragma mark - Additional Methods

- (AthleteMO *)currentAthlete {
    @synchronized (self) {
        if (!_currentAthlete) {
            NSLog(@"%s - fetching AthleteMO from database", __func__);
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Athlete"];
            
            NSError *error = nil;
            NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (!results) {
                NSLog(@"Error fetching Athlete objects %@\n%@", [error localizedDescription], [error userInfo]);
                abort();
            }
            _currentAthlete = [results firstObject];
        }
    }
    
    return _currentAthlete;
}

@end
