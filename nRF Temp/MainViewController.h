//
//  MainViewController.h
//  nRF Temp
//
//  Created by Monster on 14-3-31.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "PersonInfoCell.h"
#import "LastHistoryCell.h"
#import "TemperatureFob.h"
#import "TemperatureFobCell.h"
#import "ConnectionManager.h"
#import "PersonViewController.h"
#import "PersonDetailInfo.h"
#import "RecordViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ConnectionManagerDelegate,TemperatureFobDelegate>
{
    NSArray* _personInfoArray;
    BOOL _haveDevice;
    NSTimer* _checkStatusTimer;
    CGFloat _lastValue;
}
@property (weak, nonatomic) IBOutlet UIView *colorBg;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UIImageView *temp1;
@property (weak, nonatomic) IBOutlet UIImageView *temp2;
@property (weak, nonatomic) IBOutlet UIImageView *temp3;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIView *lowPanelView;
@property (nonatomic, retain)UIView* lowPanel2View;
@property (weak, nonatomic) IBOutlet UIImageView *plotImageView;

@property (weak, nonatomic) IBOutlet UIView *temperaturePanel;
@property (weak, nonatomic) IBOutlet UIView *checkStatusView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UIButton *openBgButton;
- (IBAction)openBgButtonTouch:(UIButton *)sender;


@property(nonatomic,retain)PersonDetailInfo* detailInfo;
@property(nonatomic,retain)TemperatureFob* fob;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
