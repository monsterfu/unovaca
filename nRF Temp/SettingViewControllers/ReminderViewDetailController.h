//
//  ReminderViewDetailController.h
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import <UIKit/UIKit.h>
#import "eventRepeatViewCell.h"
#import "eventTimeViewCell.h"
#import "eventContentViewCell.h"
#import "EventReminderModel.h"


@interface ReminderViewDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,eventRepeatViewCellDelegate,eventContentViewCellDelegate>
{
    eventContentViewCell* _contentCell;
    eventTimeViewCell* _timeCell;
    eventRepeatViewCell* _repeatCell;
}

@property (strong, nonatomic) UILocalNotification *localNotice;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isAdd;

- (IBAction)datePickerChanged:(UIDatePicker *)sender;


@property (nonatomic, strong)EventReminderModel* reminderModel;

@end
