//
//  eventReminderCell.h
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import <UIKit/UIKit.h>
#import "EventReminderModel.h"

@protocol eventReminderCellDelegate <NSObject>

-(void)switchChanged:(BOOL)on index:(NSUInteger)index;

@end

@interface eventReminderCell : UITableViewCell
{
    id<eventReminderCellDelegate>delegate;
}
@property (weak, nonatomic) id<eventReminderCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *eventContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallContentLabel;
@property (nonatomic, strong)EventReminderModel* eventReminderModel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

- (IBAction)switchChanged:(UISwitch *)sender;
@end
