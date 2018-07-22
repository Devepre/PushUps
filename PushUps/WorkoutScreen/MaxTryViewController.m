#import "MaxTryViewController.h"

@interface MaxTryViewController ()

@end

@implementation MaxTryViewController

@synthesize countLabel;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    self.countLabel.text = @"0";
    self.increase = YES;
    
}

#pragma mark - Super Overrides

- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    
    int32_t currentCount = [self.countLabel.text intValue];
    [self updateTotalMaxWithNewValue:currentCount];
    [self addToTotalCount:currentCount];
    
    [super performDataSavingProcess];
}

@end
