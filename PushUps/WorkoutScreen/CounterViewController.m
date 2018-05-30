#import "CounterViewController.h"
#import "DataController.h"
#import "PushUps+CoreDataModel.h"

static CGFloat const UITableViewEdgeInsetTop = 20.f;
static CGFloat const cheatSeconds = 1.14f;

@interface CounterViewController ()

@property (strong, nonatomic) NSDate                 *timeShot;
@property (assign, nonatomic) NSTimeInterval          timeInterval;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation CounterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
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

#pragma mark - UITableViewDelegate
// Centering headers
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s segue idenitfier: %@", __func__, segue.identifier);
    [self unsubscribeFromProximity];
    [self performDataSavingProcess];
}

#pragma mark - Actions

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"%s", __func__);
    [self countStepIncrease:self.increase];
}

#pragma mark - Additional Methods

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    NSLog(@"%s", __func__);
    if ([UIDevice.currentDevice proximityState]) {
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
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    UIDevice.currentDevice.proximityMonitoringEnabled = NO;
}

#pragma mark - Supplement methods

- (BOOL)updateCurrentMaxWithNewValue:(int32_t)newMax {
    NSLog(@"%s", __func__);
    BOOL result = NO;
    int32_t currentMax = [DataController sharedInstance].currentAthlete.currentMax;
    if (newMax > currentMax) {
        [DataController sharedInstance].currentAthlete.currentMax = newMax;
        result = YES;
    }
    
    return result;
}

- (void)addToTotalCount:(int32_t)count {
    NSLog(@"%s", __func__);
    int64_t totalCount = [DataController sharedInstance].currentAthlete.totalCount;
    totalCount += (int64_t)count;
    [DataController sharedInstance].currentAthlete.totalCount = totalCount;
}

- (void)saveManagedObjecContext {
    NSLog(@"%s", __func__);
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

// Method to override
- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    ;
}

@end
