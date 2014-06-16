//
//  LimitWarningViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-10.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"

@interface LimitWarningViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    UITableViewCell* _mostCell;
    
    NSUInteger _mostInt;
    
    UIBarButtonItem* _saveButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
