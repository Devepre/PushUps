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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    int32_t currentCount = self.repetitions;
    [self updateCurrentMaxWithNewValue:currentCount];
    [self addToTotalCount:currentCount];
    
    [self saveManagedObjecContext];
}

@end
