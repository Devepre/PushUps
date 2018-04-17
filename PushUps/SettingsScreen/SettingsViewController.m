#import "SettingsViewController.h"
#import "DataController.h"
#import <CoreData/CoreData.h>
#import "PushUps+CoreDataModel.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.managedObjectContext = [DataController sharedInstance].managedObjectContext;
}

#pragma mark - Actions
- (IBAction)createDefaultDBAction:(UIButton *)sender {
    [self createDefaultDB];
}

- (IBAction)deleteDBAction:(UIButton *)sender {
    [[DataController sharedInstance] deleteStore];
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

- (void)createDefaultDB {
    [self createSessionWithTitle:@"0-5 push-ups" andMinValue:0 andMaxValue:5];
    [self createSessionWithTitle:@"6-10 push-ups" andMinValue:6 andMaxValue:10];
    [self createSessionWithTitle:@"11-20 push-ups" andMinValue:11 andMaxValue:20];
}

- (void)createSessionWithTitle:(NSString *)title andMinValue:(int32_t)minValue andMaxValue:(int32_t)maxValue {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Session"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    fetchRequest.predicate = predicate;
    NSError *requestError = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest: fetchRequest
                                                                error:&requestError];
    if ([objects count] > 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[NSString stringWithFormat:@"Session %@ already exist", title]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        SessionMO *newManagedObject = [[SessionMO alloc] initWithContext:self.managedObjectContext];
        newManagedObject.title = title;
        newManagedObject.minValue = minValue;
        newManagedObject.maxValue = maxValue;
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

@end
