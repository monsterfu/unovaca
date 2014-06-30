//
//  LastHistoryCell.m
//  nRF Temp
//
//  Created by Monster on 14-4-10.
//
//

#import "LastHistoryCell.h"

@implementation LastHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTemperatureFob:(TemperatureFob *)info person:(PersonDetailInfo*)person
{
    TemperatureReading *lastReading = [info lastReadingBodyTemperature_person:person];
    if (lastReading) {
        
        NSDate* date = [NSDate dateWithTimeInterval:8*4*60*60 sinceDate:[lastReading date]];
        NSString* dateStr = [date.description substringToIndex:16];
        
        _tempLabel.text = [NSString stringWithFormat:@"%.01f ℃", lastReading.value.floatValue];
        _timeLabel.text = [NSString stringWithFormat:@"(%@)",dateStr];
    }else{
        _tempLabel.text = @"无记录";
        _timeLabel.text = @"";
    }
}
@end
