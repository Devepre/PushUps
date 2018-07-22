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
    
    self.countLabel.text = @"8";
    self.increase = NO;
    
    // Core Data
    self.currentAthlete = [DataController sharedInstance].currentAthlete;
    [self findDays];
}


#pragma mark - Super Overrides

- (void)performDataSavingProcess {
    NSLog(@"%s", __func__);
    
    int32_t currentCount = self.repetitions;
    [self addToTotalCount:currentCount];
    
    [super performDataSavingProcess];
}


#pragma mark - Core Data

- (void)findDays {
    NSLog(@"%s", __func__);
    
    self.currentSession = self.currentAthlete.currentTrainingSession;
    
    SetMO *currentSet1 = self.currentAthlete.currentTrainingSession.currentDay.currentSet;
    self.detail1.text = [NSString stringWithFormat:@"%d", currentSet1.count];

}


@end
