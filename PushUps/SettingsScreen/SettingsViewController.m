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
    [self createSessionWithTitle:@"0-5 push-ups" andMinValue:0 andMaxValue:5];
    [self createSessionWithTitle:@"6-10 push-ups" andMinValue:6 andMaxValue:10];
    [self createSessionWithTitle:@"11-20 push-ups" andMinValue:11 andMaxValue:20];
    [self createSessionWithTitle:@"21-25 push-ups" andMinValue:21 andMaxValue:25];
    [self createSessionWithTitle:@"26-30 push-ups" andMinValue:26 andMaxValue:30];
    [self createSessionWithTitle:@"31-35 push-ups" andMinValue:31 andMaxValue:35];
    [self createSessionWithTitle:@"36-40 push-ups" andMinValue:36 andMaxValue:40];
    [self createSessionWithTitle:@"41-45 push-ups" andMinValue:41 andMaxValue:45];
    [self createSessionWithTitle:@"46-50 push-ups" andMinValue:46 andMaxValue:50];
    [self createSessionWithTitle:@"51-55 push-ups" andMinValue:51 andMaxValue:55];
    [self createSessionWithTitle:@"56-60 push-ups" andMinValue:56 andMaxValue:60];
    [self createSessionWithTitle:@"60-99 push-ups" andMinValue:60 andMaxValue:99];
}

- (void)createSessionWithTitle:(NSString *)title andMinValue:(int32_t)minValue andMaxValue:(int32_t)maxValue {
    if ([self existSessionWithTitle:title]) {
        [self presentAlertErrorWithMessage:[NSString stringWithFormat:@"Session %@ already exist", title]];
    } else {
        SessionMO *newManagedObject = [[SessionMO alloc] initWithContext:self.managedObjectContext];
        newManagedObject.title = title;
        newManagedObject.minValue = minValue;
        newManagedObject.maxValue = maxValue;
        
        [self saveManagedObjecContext];
    }
}

- (void)createDayForSession:(SessionMO *)session withBreakIntervalDays:(int32_t)breakIntervalDays andRelaxIntervalSeconds:(int32_t)relaxIntervalSeconds {
    DayMO *newManagedObject = [[DayMO alloc] initWithContext:self.managedObjectContext];
    newManagedObject.belongsToSession = session;
    newManagedObject.breakIntervalDays = breakIntervalDays;
    newManagedObject.relaxIntervalSeconds = relaxIntervalSeconds;
    
    [self saveManagedObjecContext];
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
