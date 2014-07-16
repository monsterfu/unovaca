//
//  recordCell.h
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import <UIKit/UIKit.h>
#import "TemperatureReading.h"
#import "NSDate+JBCommon.h"

@interface recordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;


@property(nonatomic, retain)NSArray* recordReadingArray;

-(void)setRecordReadingArrayWithArray:(NSArray *)recordReadingArray;
@end
