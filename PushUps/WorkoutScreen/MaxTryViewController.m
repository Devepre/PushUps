#import "MaxTryViewController.h"

@interface MaxTryViewController ()

@end

@implementation MaxTryViewController

@synthesize countLabel;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countLabel.text = @"0";
    self.increase = YES;
    
}

#pragma mark - Super Overrides

- (void)performDataSavingProcess {
    [super performDataSavingProcess];
    
    int32_t currentCount = [self.countLabel.text intValue];
    [self updateCurrentMaxWithNewValue:currentCount];
    [self addToTotalCount:currentCount];
    
    [self saveManagedObjecContext];
}

@end
