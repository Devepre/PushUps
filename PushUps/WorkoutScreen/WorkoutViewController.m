#import "WorkoutViewController.h"
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "SessionMO+CoreDataProperties.h"
#import "DayMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"
#import "AppDataContainer.h"

static CGFloat const UITableViewEdgeInsetTop = 20.f;

@interface WorkoutViewController ()

@end

@implementation WorkoutViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];

    // For Plain UITableView style
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(UITableViewEdgeInsetTop, 0, tabBarHeight, 0);
    
    [self findSessionForMaxPushUps:[DataController sharedInstance].currentAthlete.currentMax];
}


- (void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}


- (void)viewDidAppear:(BOOL)animated {
    if ([DataController sharedInstance].currentAthlete.needMaxTest) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Test workout"
                                                                       message:@"Need to pass exam"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Let's do it!"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self performSegueWithIdentifier:@"showMaxTryScene"
                                                                                 sender:self];
                                                   }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not now"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - UITableViewDelegate

// Centering headers
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}


#pragma mark - Alerts

- (void)showAlertForMaxPushUps:(int32_t)maxPushUps session:(SessionMO *)session {
    NSString *title = [NSString stringWithFormat:@"Well done! Your result is\n%d push-ups!", maxPushUps];
    NSString *message = [NSString stringWithFormat:@"Assign recommended session \"%@\"?", session.title];
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
                                        NSLog(@"Ok");
                                        // Setting current Session
                                        [DataController sharedInstance].currentAthlete.currentTrainingSession = session;
                                        
                                        // Setting first Day of the Session
                                        NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"id"
                                                                                                  ascending:YES];
                                        NSArray<DayMO *> *daysArray = [session.daysArray sortedArrayUsingDescriptors:@[descriptor]];
                                        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay = [daysArray firstObject];
                                        
                                        // Setting first Set of the Day
                                        NSArray<SetMO *> *setsArray = [[daysArray firstObject].setArray sortedArrayUsingDescriptors:@[descriptor]];
                                        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay.currentSet = [setsArray firstObject];
                                        
                                        // Save context
                                        [[DataController sharedInstance] saveContext];
                                        [self updateUI];
                                    }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       NSLog(@"Cancel");
                                   }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Additional Methods

- (void)updateUI {
    NSLog(@"%s", __func__);
    self.donePushUpsLabel.text = [NSString stringWithFormat:@"%lld", [DataController sharedInstance].currentAthlete.totalCount];
    self.personalRecordPushUpsLabel.text = [NSString stringWithFormat:@"%d", [DataController sharedInstance].currentAthlete.totalMax];
    self.currentMaxPushUpsLabel.text = [NSString stringWithFormat:@"%d", [DataController sharedInstance].currentAthlete.currentMax];
    self.setsLabel.text = [DataController sharedInstance].currentAthlete.setsDescription;
    // Setting Total push-ups for set label
    NSString *totalNumberString = [NSString stringWithFormat:@"%lu", (unsigned long)[DataController sharedInstance].currentAthlete.setPushupNumber];
    self.totalPushUpsForSetLabel.text = totalNumberString;
}


- (void)findSessionForMaxPushUps:(int32_t)maxPushUps {
    NSLog(@"%s", __func__);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Session"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%d BETWEEN {minValue, maxValue}", maxPushUps];
    fetchRequest.predicate = predicate;
    NSError *requestError = nil;
    NSArray *objects = [[DataController sharedInstance].managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&requestError];
    SessionMO *session = [objects firstObject];
    NSLog(@"Corresponding session is: %@ for max: %d", session.title, maxPushUps);
    
    if ([[AppDataContainer sharedInstance].senderSegueIdentifier isEqualToString:@"maxTryStopAndSave"]) {
        [self showAlertForMaxPushUps:maxPushUps session:session];
    }
}


@end
