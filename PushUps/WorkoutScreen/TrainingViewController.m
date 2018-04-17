#import "TrainingViewController.h"
#import <AVFoundation/AVFoundation.h>

#define top_inset 20.0
#define cheatSeconds 1.14

@interface TrainingViewController ()

@property (strong, nonatomic) NSDate            *timeShot;
@property (assign, nonatomic) NSTimeInterval    timeInterval;

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
    
    self.tableView.contentInset = UIEdgeInsetsMake(top_inset, 0, 0, 0);
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
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s", __func__);
    [self unsubscribeFromProximity];

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
            [self countDown];
        } else {
            NSLog(@"Cheater detected! Time interval is %f", ABS(self.timeInterval));
        }
    }
}

- (void)countDown {
    NSLog(@"%s", __func__);
    NSInteger integerValue = [self.countLabel.text integerValue];
    --integerValue;
    self.countLabel.text = [NSString stringWithFormat:@"%d", integerValue];
}

- (void)unsubscribeFromProximity {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    UIDevice.currentDevice.proximityMonitoringEnabled = NO;
}

@end
