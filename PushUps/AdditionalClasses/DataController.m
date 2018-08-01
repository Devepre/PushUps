#import "DataController.h"

static NSString * const storeName       = @"PushUps";
static NSString * const storeProvider   = @".sqlite";
static NSString * const errorDomain     = @"com.del.sk.PushUps";

typedef NS_ENUM(NSUInteger, KSVErrorCode) {
    SKVGeneralError = 2000,
};

@implementation DataController


+ (DataController *)sharedInstance {
    static DataController *sharedInstance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        NSLog(@"%s - creating %@", __func__, NSStringFromClass([self class]));
        sharedInstance = [[DataController alloc] init];
        [sharedInstance initializeManagedObjectModel];
    });
    
    return sharedInstance;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)initializeManagedObjectModel {
    @synchronized(self) {
        NSLog(@"%s", __func__);
        // The managed object model for the application.
        if (!_managedObjectModel) {
            NSURL *modelURL = [[NSBundle mainBundle] URLForResource:storeName
                                                      withExtension:@"momd"];
            _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        }
        // It is a fatal error for the application not to be able to find and load its model
        assert(_managedObjectModel);
    }
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSLog(@"%s", __func__);
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory]
                       URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",
                                                    storeName,
                                                    storeProvider]];
    
    // Versioning lightweight
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dictionary[NSLocalizedFailureReasonErrorKey] = failureReason;
        dictionary[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:errorDomain
                                    code:SKVGeneralError
                                userInfo:dictionary];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    NSLog(@"%s", __func__);
    // Returns the managed object context for the application
    // (which is already bound to the persistent store coordinator for the application)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
    
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSLog(@"%s", __func__);
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } else {
        NSLog(@"Warning: NSManagedObjectContext is nil during saving!");
    }
}


- (void)deleteStore {
    NSLog(@"%s", __func__);
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores firstObject];
    NSError *error;
    [self.persistentStoreCoordinator destroyPersistentStoreAtURL:store.URL
                                                        withType:NSSQLiteStoreType
                                                         options:nil
                                                           error:&error];

    // Nillify Singleton data dependencies
    _currentAthlete = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
    // Initialize CoreData objects
    [self initializeManagedObjectModel];
}


#pragma mark - Additional Methods

- (AthleteMO *)currentAthlete {
    NSLog(@"%s", __func__);
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


- (NSURL *)applicationDocumentsDirectory {
    NSLog(@"%s", __func__);
    // The directory the application uses to store the Core Data store file.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
