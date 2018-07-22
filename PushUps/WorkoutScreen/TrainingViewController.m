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
    
    // Labels
    NSInteger currentSetCount = self.currentAthlete.currentTrainingSession.currentDay.currentSet.count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)currentSetCount];
    self.detail1.text = self.countLabel.text;
    self.trainingPlanNLabel.text = self.currentAthlete.setsDescription;
    
    // Business logic
    self.increase = NO;
}


#pragma mark - Super Overrides

- (void)stopCounting {
    // TODO: make sound
    [self.currentAthlete.currentTrainingSession.currentDay.currentSet markCompleted];
    
    [super stopCounting];
}

- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    
    int32_t currentCount = self.repetitions;
    [self addToTotalCount:currentCount];
    
    [super performDataSavingProcess];
}


@end
