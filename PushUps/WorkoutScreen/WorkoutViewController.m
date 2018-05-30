#import "WorkoutViewController.h"
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "SessionMO+CoreDataProperties.h"

static CGFloat const UITableViewEdgeInsetTop = 20.f;

@interface WorkoutViewController ()

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;

@end

@implementation WorkoutViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(UITableViewEdgeInsetTop, 0, 0, 0);
    
    self.managedObjectContext = [DataController sharedInstance].managedObjectContext;
    [self fetchData];
    [self fetchSession];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchData {
    NSLog(@"%s", __func__);
    AthleteMO *currentAthlete = [DataController sharedInstance].currentAthlete;
    int64_t totalCount = currentAthlete.totalCount;
    int32_t currentMax = currentAthlete.currentMax;
    self.pushUpsDoneLabel.text = [NSString stringWithFormat:@"%lld", totalCount];
    self.personalRecordLabel.text = [NSString stringWithFormat:@"%d", currentMax];
}

- (void)fetchSession {
    NSLog(@"%s", __func__);
    AthleteMO *currentAthlete = [DataController sharedInstance].currentAthlete;
    SessionMO *currentSession = currentAthlete.currentTrainingSession;
    self.setsLabel.text = currentSession.title;
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
