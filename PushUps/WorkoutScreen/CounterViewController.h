#import <UIKit/UIKit.h>

@interface CounterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (assign, nonatomic) BOOL            increase;
@property (assign, nonatomic) int32_t         repetitions;

- (void)unsubscribeFromProximity;
- (BOOL)updateTotalMaxWithNewValue:(int32_t)newMax;
- (void)addToTotalCount:(int32_t)count;
- (void)performDataSavingProcess;

@end
