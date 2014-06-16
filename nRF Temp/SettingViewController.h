//
//  SettingViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-4.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"

@interface SettingViewController : UITableViewController
{
    NSArray* _timeGapArray;
    
    UILabel* label;
    UISwitch* switchView;
}
@end
