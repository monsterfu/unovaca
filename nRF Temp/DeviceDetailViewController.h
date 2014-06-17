//
//  DeviceDetailViewController.h
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import <UIKit/UIKit.h>
#import "PersonDetailInfo.h"

@interface DeviceDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSTimer* _scanTimer;
    UITableViewCell* _scanTableViewCell;
}
@property (readwrite, nonatomic)TemperatureFob *fob;
@property(readwrite, nonatomic)PersonDetailInfo* person;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)deleteButtonTouch:(UIButton *)sender;



@end
