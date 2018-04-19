#import "MaxTryViewController.h"
#import "DataController.h"
#import "PushUps+CoreDataModel.h"

#define top_inset 20.0
#define cheatSeconds 1.14

@interface MaxTryViewController ()

@property (strong, nonatomic) NSDate            *timeShot;
@property (assign, nonatomic) NSTimeInterval    timeInterval;
@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;

@end

@implementation MaxTryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countLabel.text = @"0";
    
    self.tableView.contentInset = UIEdgeInsetsMake(top_inset, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.countLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didTapLabelWithGesture:)];
    [self.countLabel addGestureRecognizer:tapGesture];
    
    self.managedObjectContext = [DataController sharedInstance].managedObjectContext;
    
    self.timeShot = [NSDate dateWithTimeIntervalSince1970:0];
    
    UIDevice.currentDevice.proximityMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
}

// Centering headers
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s", __func__);
    [self unsubscribeFromProximity];
    
    int32_t currentCount = [self.countLabel.text intValue];
    [self updateCurrentMaxWithNewValue:currentCount];
    
    [self saveManagedObjecContext];
}

#pragma mark - Actions

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    [self countUp];
}

#pragma mark - Additional Methods

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    NSLog(@"%s", __func__);
    if ([UIDevice.currentDevice proximityState] == YES) {
        self.timeInterval = [self.timeShot timeIntervalSinceNow];
        printf("%f\n", self.timeInterval);
    } else {
        if (ABS(self.timeInterval) > cheatSeconds) {
            self.timeShot = [NSDate date];
            [self countUp];
        } else {
            NSLog(@"Cheater detected! Time interval is %f", ABS(self.timeInterval));
        }
    }
}

- (void)countUp {
    NSLog(@"%s", __func__);
    NSInteger integerValue = [self.countLabel.text integerValue];
    ++integerValue;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)integerValue];
}

- (void)unsubscribeFromProximity {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    UIDevice.currentDevice.proximityMonitoringEnabled = NO;
}

#pragma mark - Supplement methods

- (BOOL)updateCurrentMaxWithNewValue:(int32_t)newMax {
    BOOL result = NO;
    AthleteMO *currentAthlete = [self getCurrentAthlete];
    int32_t currentMax = currentAthlete.currentMax;
    if (newMax > currentMax) {
        currentAthlete.currentMax = newMax;
        result = YES;
    }
    
    return result;
}

- (AthleteMO *)getCurrentAthlete {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Athlete"];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Athlete objects %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    AthleteMO *currentAthlete = [results firstObject];
    
    return currentAthlete;
}

- (void)saveManagedObjecContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
