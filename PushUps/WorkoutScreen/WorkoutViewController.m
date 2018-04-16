#import <AVFoundation/AVFoundation.h>
#import "WorkoutViewController.h"

@interface WorkoutViewController ()

@end

@implementation WorkoutViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// Centering headers
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
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

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    if ([UIDevice.currentDevice proximityState] == YES) {
        NSLog(@"Close");
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device.hasTorch) {
            [device lockForConfiguration:nil];
            device.torchMode = device.torchMode ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
            [device unlockForConfiguration];
        }
    } else {
        NSLog(@"Not close");
    }
}

@end
