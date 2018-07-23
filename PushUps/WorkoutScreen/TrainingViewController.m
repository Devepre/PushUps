#import "TrainingViewController.h"
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "DayMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"
#import "SessionMO+CoreDataClass.h"
@import CoreData;

@interface TrainingViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *detail1;
@property (weak, nonatomic) IBOutlet UILabel *trainingPlanNLabel;

@property (strong, nonatomic) AthleteMO *currentAthlete;
@property (strong, nonatomic) SessionMO *currentSession;
@property (strong, nonatomic) DayMO     *currentDay;

@property (strong, nonatomic) SessionMO *inputSession;
@property (strong, nonatomic) DayMO     *inputDay;
@property (strong, nonatomic) SetMO     *inputSet;

@end

@implementation TrainingViewController

@synthesize countLabel;


#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    // Core Data
    self.currentAthlete = [DataController sharedInstance].currentAthlete;
    self.currentSession = self.currentAthlete.currentTrainingSession;
    
    // Inputs
    self.inputSession = self.currentAthlete.currentTrainingSession;
    self.inputDay = self.inputSession.currentDay;
    self.inputSet = self.inputDay.currentSet;
    
    [self updateUI];
    
    // Business logic
    self.increase = NO;
}


- (void)updateUI {
    // Labels
    NSInteger currentSetCount = self.currentAthlete.currentTrainingSession.currentDay.currentSet.count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)currentSetCount];
    self.detail1.text = self.countLabel.text;
    self.trainingPlanNLabel.text = self.currentAthlete.setsDescription;
}


#pragma mark - Super Overrides

- (void)countStepIncrease:(BOOL)increase {
    NSLog(@"%s", __func__);
    
    self.repetitions++;
    NSInteger integerValue = [self.countLabel.text integerValue];
    
    integerValue+= increase ? 1 : -1;
    
    if (integerValue == 0) {
        [self stopCounting];
        integerValue = [self.countLabel.text integerValue];
        self.countLabel.text = @"Rest";
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)integerValue];
    }
}


- (void)stopCounting {
    // TODO: make sound
    [self.currentAthlete.currentTrainingSession.currentDay.currentSet markCompleted];
    
    if ([self.inputDay isEqual:self.currentAthlete.currentTrainingSession.currentDay]) {
        [self updateUI];
        
        NSInteger relaxIntervalSeconds = self.currentAthlete.currentTrainingSession.currentDay.relaxIntervalSeconds;
        NSString *message = [NSString stringWithFormat:@"Take a rest for %ld seconds",
                             (long)relaxIntervalSeconds];
        [self presentAlertWithMessage:message];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                                       message:@"You've completed"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       self.currentAthlete.needMaxTest = YES;
                                                       [self performDataSavingProcess];
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
//    [super stopCounting];
}


- (void)presentAlertWithMessage:(NSString *)messageText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageText
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"I'm ready"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   [self updateUI];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)cancelSession {
    self.currentAthlete.currentTrainingSession = self.inputSession;
    self.currentAthlete.currentTrainingSession.currentDay = self.inputDay;
    self.currentAthlete.currentTrainingSession.currentDay.currentSet = self.inputSet;
}


- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    
    if ([self.inputDay isEqual:self.currentAthlete.currentTrainingSession.currentDay]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Workout isn't completed"
                                                                       message:@"You will need to repeat it"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self cancelSession];
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        self.currentAthlete.needMaxTest = YES;
    }
    
    int32_t currentCount = self.repetitions;
    [self addToTotalCount:currentCount];
    
    [super performDataSavingProcess];
}


@end
