#import "MaxTryViewController.h"

@interface MaxTryViewController ()

@end

@implementation MaxTryViewController

@synthesize countLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countLabel.text = @"0";
    self.increase = YES;
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    int32_t currentCount = [self.countLabel.text intValue];
    [self updateCurrentMaxWithNewValue:currentCount];
    [self addToTotalCount:currentCount];
    
    [self saveManagedObjecContext];
}

@end
