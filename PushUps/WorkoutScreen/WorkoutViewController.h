#import <UIKit/UIKit.h>

@interface WorkoutViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *donePushUpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalRecordPushUpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMaxPushUpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *stillToDoPushUpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedFinishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTrainingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushUpsForSetLabel;

@end
