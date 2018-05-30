#import <UIKit/UIKit.h>

@interface WorkoutViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *pushUpsDoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushUpsStillToDoLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedFinishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTrainingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushUpsForSetLabel;

@end
