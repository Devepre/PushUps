#import "SettingsViewController.h"
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "SessionMO+CoreDataProperties.h"
#import "DayMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"

@import CoreData;

static CGFloat const UITableViewEdgeInsetTop = 20.f;

@interface SettingsViewController ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation SettingsViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(UITableViewEdgeInsetTop, 0, 0, 0);
    self.managedObjectContext = [DataController sharedInstance].managedObjectContext;
}


#pragma mark - Actions
- (IBAction)createDefaultDBAction:(UIButton *)sender {
    NSLog(@"%s", __func__);
    [self createDefaultDB];
}


- (IBAction)deleteDBAction:(UIButton *)sender {
    NSLog(@"%s", __func__);
    [[DataController sharedInstance] deleteStore];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Additional Methods

- (void)createDefaultDB {
    // Creating the Athlete User
    NSManagedObjectContext *context = [DataController sharedInstance].managedObjectContext;
    NSEntityDescription *athleteEntity = [NSEntityDescription entityForName:@"Athlete"
                                              inManagedObjectContext:context];
    AthleteMO __unused *athlete = [[AthleteMO alloc] initWithEntity:athleteEntity
                                     insertIntoManagedObjectContext:[DataController sharedInstance].managedObjectContext];
    
    // Creating Session->Day->Set
    NSArray *sessionMinValues = @[@0, @6, @11, @21, @26, @31, @36, @41, @46, @51, @56, @61];
    NSArray *sessionMaxValues = @[@5, @10, @20, @25, @30, @35, @40, @45, @50, @55, @60, @99];
    
    NSMutableArray *sessionsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < sessionMaxValues.count; i++) {
        SessionMO *currentSession = [self createSessionWithTitle:[NSString stringWithFormat:@"%@ - %@ push-ups",
                                                                  [sessionMinValues objectAtIndex:i],
                                                                  [sessionMaxValues objectAtIndex:i]]
                                                     minValue:[[sessionMinValues objectAtIndex:i] intValue]
                                                     maxValue:[[sessionMaxValues objectAtIndex:i] intValue]
                                                           id:i];
        [sessionsArray addObject:currentSession];
    }
    
    athlete.sessionsArray = [[NSSet alloc] initWithArray:sessionsArray];
    
    int index = 0;
    // Session 1
    NSArray *setCounts1 = @[@2, @3, @2, @2, @3];
    NSArray *setCounts2 = @[@3, @4, @2, @3, @4];
    NSArray *setCounts3 = @[@4, @5, @4, @4, @5];
    NSArray *setCounts4 = @[@5, @6, @4, @4, @6];
    NSArray *setCounts5 = @[@5, @6, @4, @4, @7];
    NSArray *setCounts6 = @[@5, @7, @5, @5, @7];
    NSArray *days = @[setCounts1, setCounts2, setCounts3, setCounts4, setCounts5, setCounts6];
    NSArray *dayRelaxIntervalSeconds = @[@60, @90, @120, @60, @90, @120];
    NSArray *dayBreakIntervalDays = @[@1, @1, @2, @1, @1, @2];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                    dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 2
    setCounts1 = @[@5,  @6,  @4,  @4,  @5];
    setCounts2 = @[@6,  @7,  @6,  @6,  @7];
    setCounts3 = @[@8,  @10, @7,  @7,  @10];
    setCounts4 = @[@9,  @11, @8,  @8,  @11];
    setCounts5 = @[@10, @12, @9,  @9,  @13];
    setCounts6 = @[@12, @13, @10, @10, @15];
    days = @[setCounts1, setCounts2, setCounts3, setCounts4, setCounts5, setCounts6];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                    dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 3
    setCounts1 = @[@8,  @9,  @7,  @7,  @8];
    setCounts2 = @[@9,  @10, @8,  @8,  @10];
    setCounts3 = @[@11, @13, @9,  @9,  @13];
    setCounts4 = @[@12, @14, @10, @10, @15];
    setCounts5 = @[@13, @15, @11, @11, @17];
    setCounts6 = @[@14, @16, @13, @13, @19];
    days = @[setCounts1, setCounts2, setCounts3, setCounts4, setCounts5, setCounts6];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                    dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 4
    setCounts1 = @[@12, @17, @13, @13, @17];
    setCounts2 = @[@14, @19, @14, @14, @19];
    setCounts3 = @[@16, @21, @15, @15, @21];
    setCounts4 = @[@18, @22, @16, @16, @21];
    setCounts5 = @[@20, @25, @20, @20, @23];
    setCounts6 = @[@23, @28, @22, @22, @25];
    days = @[setCounts1, setCounts2, setCounts3, setCounts4, setCounts5, setCounts6];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                    dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 5
    setCounts1 = @[@14, @18, @14, @14, @20];
    setCounts2 = @[@20, @25, @15, @15, @23];
    setCounts3 = @[@20, @27, @18, @18, @25];
    setCounts4 = @[@21, @25, @21, @21, @27];
    setCounts5 = @[@25, @29, @25, @25, @30];
    setCounts6 = @[@29, @33, @29, @29, @33];
    days = @[setCounts1, setCounts2, setCounts3, setCounts4, setCounts5, setCounts6];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                    dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 6
    setCounts1 = @[@17, @19, @15, @15, @20];
    setCounts2 = @[@10, @10, @13, @13, @10, @10, @9,  @25];
    setCounts3 = @[@13, @13, @15, @15, @12, @12, @10, @30];
    days = @[setCounts1, setCounts2, setCounts3];
    dayRelaxIntervalSeconds = @[@60, @45, @45];
    dayBreakIntervalDays = @[@1, @1, @2];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                    dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 7
    setCounts1 = @[@22, @24, @20, @20, @25];
    setCounts2 = @[@15, @15, @18, @18, @15, @15, @14, @30];
    setCounts3 = @[@18, @18, @20, @20, @17, @17, @15, @35];
    days = @[setCounts1, setCounts2, setCounts3];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                      withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                          dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 8
    setCounts1 = @[@27, @29, @25, @25, @35];
    setCounts2 = @[@19, @19, @22, @22, @18, @18, @22, @35];
    setCounts3 = @[@20, @20, @24, @24, @20, @20, @22, @40];
    days = @[setCounts1, setCounts2, setCounts3];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                      withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                          dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 9
    setCounts1 = @[@30, @34, @30, @30, @40];
    setCounts2 = @[@19, @19, @23, @23, @19, @19, @22, @37];
    setCounts3 = @[@20, @20, @27, @27, @21, @21, @21, @44];
    days = @[setCounts1, setCounts2, setCounts3];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                      withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                          dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 10
    setCounts1 = @[@30, @39, @35, @35, @42];
    setCounts2 = @[@20, @20, @23, @23, @20, @20, @18, @18, @53];
    setCounts3 = @[@22, @22, @30, @30, @25, @25, @18, @18, @55];
    days = @[setCounts1, setCounts2, setCounts3];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                      withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                          dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 11
    setCounts1 = @[@30, @44, @40, @40, @55];
    setCounts2 = @[@22, @22, @27, @27, @24, @23, @18, @18, @58];
    setCounts3 = @[@26, @26, @33, @33, @26, @26, @22, @22, @60];
    days = @[setCounts1, setCounts2, setCounts3];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                      withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                          dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    // Session 12
    setCounts1 = @[@35, @49, @45, @45, @55];
    setCounts2 = @[@22, @22, @30, @30, @24, @24, @18, @18, @59];
    setCounts3 = @[@28, @28, @35, @35, @27, @27, @23, @23, @60];
    days = @[setCounts1, setCounts2, setCounts3];
    [[sessionsArray objectAtIndex:index++] setDaysArray: [self createDaysFromDaysArray:days
                                                      withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                                                          dayBreakIntervalDaysArray:dayBreakIntervalDays]];
    
    [self saveManagedObjecContext];
}


- (SessionMO *)createSessionWithTitle:(NSString *)title minValue:(int32_t)minValue maxValue:(int32_t)maxValue id:(int32_t)objectID {
    SessionMO *newSession = nil;
    if ([self existSessionWithTitle:title]) {
        [self presentAlertErrorWithMessage:[NSString stringWithFormat:@"Session %@ already exist", title]];
    } else {
        // Creating new session
        NSManagedObjectContext *context = [DataController sharedInstance].managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session"
                                                  inManagedObjectContext:context];
        newSession = [[SessionMO alloc] initWithEntity:entity
                        insertIntoManagedObjectContext:[DataController sharedInstance].managedObjectContext];
        
        newSession.id = objectID;
        newSession.title = title;
        newSession.minValue = minValue;
        newSession.maxValue = maxValue;
    }
    
    return newSession;
}


- (NSSet *)createDaysFromDaysArray:(NSArray *)days withDayRelaxIntervalSecondsArray:(NSArray *)dayRelaxIntervalSeconds  dayBreakIntervalDaysArray:(NSArray *)dayBreakIntervalDays {
    NSMutableSet *daysForSession = [[NSMutableSet alloc] init];
    for (int i = 0; i < days.count; i++) {
        DayMO *currentDay = [self createDayWithRelaxIntervalSeconds:[[dayRelaxIntervalSeconds objectAtIndex:i] intValue]
                                               breakIntervalDays:[[dayBreakIntervalDays objectAtIndex:i] intValue]
                                                              id:i];
        currentDay.setArray = [self createSetsFromCountsArray:[days objectAtIndex:i]];
        [daysForSession addObject:currentDay];
    }
    return [NSSet setWithSet:daysForSession];
}


- (DayMO *)createDayWithRelaxIntervalSeconds:(int32_t)relaxIntervalSeconds breakIntervalDays:(int32_t)breakIntervalDays id:(int32_t)objectID {
    // Creating Day
    NSManagedObjectContext *context = [DataController sharedInstance].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day"
                                              inManagedObjectContext:context];
    DayMO *newDay = [[DayMO alloc] initWithEntity:entity
                   insertIntoManagedObjectContext:[DataController sharedInstance].managedObjectContext];
    
    newDay.id = objectID;
    newDay.relaxIntervalSeconds = relaxIntervalSeconds;
    newDay.breakIntervalDays = breakIntervalDays;
    
    return newDay;
}


- (NSSet<SetMO *> *)createSetsFromCountsArray:(NSArray *)counts {
    NSMutableSet *result = [[NSMutableSet alloc] init];
    
    for (int i = 0; i < counts.count; ++i) {
        [result addObject:[self createSetWithCount:[[counts objectAtIndex:i] intValue] id:i]];
    }
    
    return [NSSet setWithSet:result];
}


- (SetMO *)createSetWithCount:(int32_t)count id:(int32_t)objectID {
    // Creating Set
    NSManagedObjectContext *context = [DataController sharedInstance].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Set"
                                              inManagedObjectContext:context];
    SetMO *newSet  = [[SetMO alloc] initWithEntity:entity
                    insertIntoManagedObjectContext:[DataController sharedInstance].managedObjectContext];
    
    newSet.id = objectID;
    newSet.completed = NO;
    newSet.count = count;
    
    return newSet;
}


#pragma mark - Supplement methods

- (void)saveManagedObjecContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (BOOL)existSessionWithTitle:(NSString *)title {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Session"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    fetchRequest.predicate = predicate;
    NSError *requestError = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&requestError];
    return [objects count] > 0;
}


- (void)presentAlertErrorWithMessage:(NSString *)messageText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:messageText
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
