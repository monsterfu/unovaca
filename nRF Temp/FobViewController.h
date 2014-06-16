//
//  FobViewController.h
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import <UIKit/UIKit.h>

#import "PersonDetailInfo.h"
#import "BatteryView.h"
#import "NewGraphViewController.h"
#import "PublicDefine.h"

@interface FobViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TemperatureFobDelegate>
@property (strong, nonatomic) TemperatureFob *fob;
@property (strong, nonatomic) PersonDetailInfo* person;
@property(nonatomic, retain)NSString* dateStr;
@property (strong, nonatomic)NSArray* readings;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet BatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *signalStrengthImage;

- (void) setFob:(TemperatureFob *)fob;
- (IBAction) nameChanged:(id)sender;

@end
