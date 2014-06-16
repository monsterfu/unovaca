//
//  RecordViewController.h
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "PersonDetailInfo.h"
#import "recordCell.h"
#import "FobViewController.h"

@interface RecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _recordsOfMonthArray;
}

@property(readwrite,nonatomic)TemperatureFob* fob;
@property(nonatomic,retain)PersonDetailInfo* person;
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;
@property (weak, nonatomic) IBOutlet UIButton *newestDataButton;
- (IBAction)newestDataButtonTouch:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *blackView;

- (IBAction)selectDateButtonTouched:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
