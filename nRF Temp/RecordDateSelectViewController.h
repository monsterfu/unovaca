//
//  RecordDateSelectViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-16.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"

@interface RecordDateSelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableViewCell* _cell;
    
    NSUInteger yearIndex;
    NSUInteger monthIndex;
    
    NSString* _yearSr;
    NSString* _monthSr;
}
//@property(nonatomic, retain)NSDate* selectdate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)done:(UIBarButtonItem *)sender;

@end
