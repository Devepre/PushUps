#import "SettingsViewController.h"
#import "DataController.h"
#import <CoreData/CoreData.h>
#import "PushUps+CoreDataModel.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.managedObjectContext = [DataController sharedInstance].managedObjectContext;
}

#pragma mark - Actions
- (IBAction)createDefaultDBAction:(UIButton *)sender {
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
    NSArray *sessionMinValues = @[@0, @6, @11, @21, @26, @31, @36, @41, @46, @51, @56, @61];
    NSArray *sessionMaxValues = @[@5, @10, @20, @25, @30, @35, @406, @45, @50, @55, @60, @99];
    
    NSMutableArray *sessionsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < sessionMaxValues.count; i++) {
        SessionMO *currentSession = [self createSessionWithTitle:[NSString stringWithFormat:@"%@ - %@ push-ups",
                                                                   [sessionMinValues objectAtIndex:i],
                                                                   [sessionMaxValues objectAtIndex:i]]
                                                      andMinValue:0
                                                      andMaxValue:5
                                                            andId:0];
        [sessionsArray addObject:currentSession];
    }
    
    SessionMO *session0 = [sessionsArray objectAtIndex:0];
    NSArray *setCounts1 = @[@2, @3, @2, @2, @3];
    NSArray *setCounts2 = @[@3, @4, @2, @3, @4];
    NSArray *setCounts3 = @[@4, @5, @4, @4, @5];
    NSArray *setCounts4 = @[@5, @6, @4, @4, @6];
    NSArray *setCounts5 = @[@5, @6, @4, @4, @7];
    NSArray *setCounts6 = @[@5, @7, @5, @5, @7];
    NSArray *days = @[setCounts1, setCounts2, setCounts3, setCounts4, setCounts5, setCounts6];
    NSArray *dayRelaxIntervalSeconds = @[@60, @90, @120, @60, @90, @120];
    NSArray *dayBreakIntervalDays = @[@1, @1, @2, @1, @1, @2];
    
    session0.daysArray = [self createDaysFromDaysArray:days
                        withDayRelaxIntervalSecondsArray:dayRelaxIntervalSeconds
                            andDayBreakIntervalDaysArray:dayBreakIntervalDays];
    
    [self saveManagedObjecContext];
}

- (SessionMO *)createSessionWithTitle:(NSString *)title andMinValue:(int32_t)minValue andMaxValue:(int32_t)maxValue andId:(int32_t)objectID {
    SessionMO *newSession = nil;
    if ([self existSessionWithTitle:title]) {
        [self presentAlertErrorWithMessage:[NSString stringWithFormat:@"Session %@ already exist", title]];
    } else {
        newSession = [[SessionMO alloc] initWithContext:self.managedObjectContext];
        newSession.id = objectID;
        newSession.title = title;
        newSession.minValue = minValue;
        newSession.maxValue = maxValue;
    }
    
    return newSession;
}

- (NSSet *)createDaysFromDaysArray:(NSArray *)days withDayRelaxIntervalSecondsArray:(NSArray *)dayRelaxIntervalSeconds  andDayBreakIntervalDaysArray:(NSArray *)dayBreakIntervalDays {
    NSMutableSet *daysForSession = [[NSMutableSet alloc] init];
    for (int i = 0; i < days.count; i++) {
        DayMO *currentDay = [self createDayWithRelaxIntervalSeconds:[[dayRelaxIntervalSeconds objectAtIndex:i] intValue]
                                               andBreakIntervalDays:[[dayBreakIntervalDays objectAtIndex:i] intValue]
                                                              andID:i];
        currentDay.setArray = [self createSetsFromCountsArray:[days objectAtIndex:i]];
        [daysForSession addObject:currentDay];
    }
    return [NSSet setWithSet:daysForSession];
}

- (DayMO *)createDayWithRelaxIntervalSeconds:(int32_t)relaxIntervalSeconds andBreakIntervalDays:(int32_t)breakIntervalDays andID:(int32_t)objectID {
    DayMO *newDay = [[DayMO alloc] initWithContext:self.managedObjectContext];
    newDay.id = objectID;
    newDay.relaxIntervalSeconds = relaxIntervalSeconds;
    newDay.breakIntervalDays = breakIntervalDays;
    
    return newDay;
}

- (NSSet<SetMO *> *)createSetsFromCountsArray:(NSArray *)counts {
    NSMutableSet *result = [[NSMutableSet alloc] init];
    
    for (int i = 0; i < counts.count; ++i) {
        [result addObject:[self createSetWithCount:[[counts objectAtIndex:i] intValue] andId:i]];
    }
    
    return [NSSet setWithSet:result];
}

- (SetMO *)createSetWithCount:(int32_t)count andId:(int32_t)objectID {
    SetMO *newSet = [[SetMO alloc] initWithContext:self.managedObjectContext];
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
    NSArray *objects = [self.managedObjectContext executeFetchRequest: fetchRequest
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
