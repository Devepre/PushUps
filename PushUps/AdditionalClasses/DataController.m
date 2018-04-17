#import "DataController.h"

@implementation DataController

+ (DataController *)sharedInstance {
    static DataController *sharedInstance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
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
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)deleteStore {
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentContainer.persistentStoreCoordinator;
    NSPersistentStore *store = [storeCoordinator.persistentStores firstObject];
    NSError *error;
    NSURL *storeURL = store.URL;
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
}

@end
