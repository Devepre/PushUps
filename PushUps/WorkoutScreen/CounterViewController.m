#import "CounterViewController.h"
#import "DataController.h"
#import "AppDataContainer.h"
#import "AthleteMO+CoreDataProperties.h"

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
    [AppDataContainer sharedInstance].senderSegueIdentifier = segue.identifier;

    [self unsubscribeFromProximity];
    if ([segue.identifier isEqualToString:@"Cancel"]) {
        return;
    }
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

    if (increase) {
        ++integerValue;
    } else if (integerValue > 1) {
        --integerValue;
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)integerValue];
        [self stopCounting];
    }

    self.repetitions++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)integerValue];
}

- (void)unsubscribeFromProximity {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    UIDevice.currentDevice.proximityMonitoringEnabled = NO;
}


#pragma mark - Supplement methods

- (BOOL)updateTotalMaxWithNewValue:(int32_t)newMax {
    NSLog(@"%s", __func__);
    BOOL result = NO;
    [DataController sharedInstance].currentAthlete.currentMax = newMax;
    // Setting new Total Max
    int32_t currentTotalMax = [DataController sharedInstance].currentAthlete.totalMax;
    if (newMax > currentTotalMax) {
        [DataController sharedInstance].currentAthlete.totalMax = newMax;
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


- (void)stopCounting {
    // TODO: make sound
    
    [self presentAlertErrorWithMessage:@"Enough!"];
}


- (void)presentAlertErrorWithMessage:(NSString *)messageText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageText
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


// Method to override
- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    
    // Save context
    [[DataController sharedInstance] saveContext];
}

@end
