#import "TrainingViewController.h"

@interface TrainingViewController ()

@end

@implementation TrainingViewController

@synthesize countLabel;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    self.countLabel.text = @"8";
    self.increase = NO;
    
}

#pragma mark - Super Overrides

- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    [super performDataSavingProcess];
    
    int32_t currentCount = self.repetitions;
    [self updateTotalMaxWithNewValue:currentCount];
    [self addToTotalCount:currentCount];
    
    [self saveManagedObjecContext];
}

@end
