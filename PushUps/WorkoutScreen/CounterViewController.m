#import "CounterViewController.h"
#import "DataController.h"
#import "PushUps+CoreDataModel.h"

static CGFloat const UITableViewEdgeInsetTop = 20.f;
static CGFloat const cheatSeconds = 1.14f;

@interface CounterViewController ()

@property (strong, nonatomic) NSDate                                *timeShot;
@property (assign, nonatomic) NSTimeInterval                         timeInterval;
@property (strong, nonatomic) NSManagedObjectContext                *managedObjectContext;
@property (strong, nonatomic, getter=getCurrentAthlete) AthleteMO   *currentAthlete;

@end

@implementation CounterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(UITableViewEdgeInsetTop, 0, 0, 0);
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
    [self performDataSavingProcess];
}

#pragma mark - Actions

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    [self countStepIncrease:self.increase];
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
            [self countStepIncrease:self.increase];
        } else {
            NSLog(@"Cheater detected! Time interval is %f", ABS(self.timeInterval));
        }
    }
}

- (void)countStepIncrease:(BOOL)increase {
    NSLog(@"%s", __func__);
    NSInteger integerValue = [self.countLabel.text integerValue];
    integerValue+= increase ? 1 : -1;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)integerValue];
    
    self.repetitions++;
}

- (void)unsubscribeFromProximity {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    UIDevice.currentDevice.proximityMonitoringEnabled = NO;
}

#pragma mark - Getters and Setters

- (AthleteMO *)getCurrentAthlete {
    AthleteMO *currentAthlete = _currentAthlete;
    if (!currentAthlete) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Athlete"];
        
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (!results) {
            NSLog(@"Error fetching Athlete objects %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        currentAthlete = [results firstObject];
    }
    
    return currentAthlete;
}

#pragma mark - Supplement methods

- (BOOL)updateCurrentMaxWithNewValue:(int32_t)newMax {
    BOOL result = NO;
    int32_t currentMax = self.currentAthlete.currentMax;
    if (newMax > currentMax) {
        self.currentAthlete.currentMax = newMax;
        result = YES;
    }
    
    return result;
}

- (void)addToTotalCount:(int32_t)count {
    int64_t totalCount = self.currentAthlete.totalCount;
    totalCount += (int64_t)count;
    self.currentAthlete.totalCount = totalCount;
}

- (void)saveManagedObjecContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

// Method to override
- (void)performDataSavingProcess {
    ;
}

@end
