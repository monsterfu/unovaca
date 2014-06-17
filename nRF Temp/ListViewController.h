//
//  MasterViewController.h
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import <UIKit/UIKit.h>


#import "FobViewController.h"
#import "ConnectionManager.h"
#import "TemperatureFob.h"
#import "TemperatureFobCell.h"
#import "PersonDetailInfo.h"
#import "TemperatureNewFobCell.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ConnectionManagerDelegate, TemperatureFobDelegate,TemperatureFobCellDelegate,UIAlertViewDelegate>
{
    NSMutableArray* _fobArray;
    
    TemperatureNewFobCell* _newFobCell;
    TemperatureFobCell * _storeFobCell;
    
    UIAlertView* _alertView;
    
    TemperatureFob* _fob;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addActivityIndicator;

@property(nonatomic,retain)PersonDetailInfo* detailInfo;

- (IBAction)scanButtonTouch:(UIButton *)sender;

@end
