#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
}

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
