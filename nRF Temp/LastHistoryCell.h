//
//  LastHistoryCell.h
//  nRF Temp
//
//  Created by Monster on 14-4-10.
//
//

#import <UIKit/UIKit.h>
#import "TemperatureFob.h"

@interface LastHistoryCell : UITableViewCell

@property (nonatomic, strong) TemperatureFob * temperatureFob;


@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noHistoryRemindLabel;
@end