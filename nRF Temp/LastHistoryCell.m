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
        
        NSLocale *cnTime = [[NSLocale alloc]initWithLocaleIdentifier:[[USER_DEFAULT objectForKey:@"AppleLanguages"]objectAtIndex:0]];
        
        NSString* dateStr = [[[lastReading date] descriptionWithLocale:cnTime]substringToIndex:10];
        
        _tempLabel.text = [NSString stringWithFormat:@"%.01f ℃", lastReading.value.floatValue];
        _timeLabel.text = [NSString stringWithFormat:@"(%@)",dateStr];
        
    }else{
        _noHistoryRemindLabel.text = NSLocalizedString(@"无记录",nil);
        [_noHistoryRemindLabel setHidden:NO];
        _tempLabel.text = NSLocalizedString(@"无记录",nil);
        [_tempLabel setHidden:YES];
        _timeLabel.text = @"";
    }
}
@end
