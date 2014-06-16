//
//  TimeGapViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-9.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "SettingViewController.h"

@interface TimeGapViewController : UITableViewController
{
    NSArray* _timeGapArray;
    NSUInteger _selectItem;
}
@end
