#import "TrainingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TrainingViewController ()

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
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
    if ([UIDevice.currentDevice proximityState] == YES) {
        [self countDown];
    }
}

- (void)countDown {
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
