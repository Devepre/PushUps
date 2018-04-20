#import "TrainingViewController.h"

@interface TrainingViewController ()

@end

@implementation TrainingViewController

@synthesize countLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countLabel.text = @"8";
    self.increase = NO;
    
}

#pragma mark - Super Overrides

- (void)performDataSavingProcess {
    [super performDataSavingProcess];
    
    int32_t currentCount = self.repetitions;
    [self updateCurrentMaxWithNewValue:currentCount];
    [self addToTotalCount:currentCount];
    
    [self saveManagedObjecContext];
}

@end
