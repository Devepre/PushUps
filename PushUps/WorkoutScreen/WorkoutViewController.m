#import "WorkoutViewController.h"
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "SessionMO+CoreDataProperties.h"

static CGFloat const UITableViewEdgeInsetTop = 20.f;

@interface WorkoutViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) AthleteMO *currentAthlete;
@property (strong, nonatomic) SessionMO *currentSession;

@end

@implementation WorkoutViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(UITableViewEdgeInsetTop, 0, 0, 0);
    
    self.managedObjectContext = [DataController sharedInstance].managedObjectContext;
    [self fetchData];
    [self fillLabels];
    [self findSessionForMaxPushUps:self.currentAthlete.currentMax];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)findSessionForMaxPushUps:(int32_t)maxPushUps {
    NSLog(@"%s", __func__);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Session"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%d BETWEEN {minValue, maxValue}", maxPushUps];
    fetchRequest.predicate = predicate;
    NSError *requestError = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&requestError];
    SessionMO *session = [objects firstObject];
    NSLog(@"Corresponding session is: %@ for max: %d", session.title, maxPushUps);
}

- (void)fetchData {
    NSLog(@"%s", __func__);
    self.currentAthlete = [DataController sharedInstance].currentAthlete;
    self.currentSession = self.currentAthlete.currentTrainingSession;
}

- (void)fillLabels {
    NSLog(@"%s", __func__);
    self.donePushUpsLabel.text = [NSString stringWithFormat:@"%lld", self.currentAthlete.totalCount];
    self.personalRecordPushUpsLabel.text = [NSString stringWithFormat:@"%d", self.currentAthlete.totalMax];
    self.currentMaxPushUpsLabel.text = [NSString stringWithFormat:@"%d", self.currentAthlete.currentMax];
    self.setsLabel.text = self.currentSession.title;
}

#pragma mark - UITableViewDelegate

// Centering headers
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Additional Methods


@end
