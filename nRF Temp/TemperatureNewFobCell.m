//
//  TemperatureNewFobCell.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "TemperatureNewFobCell.h"

@implementation TemperatureNewFobCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setFob:(TemperatureFob*) fob
{
    TemperatureReading *lastReading = [fob lastReading];
    
    if ([USER_DEFAULT objectForKey:fob.uuid]) {
        [_fobNameLabel setText:[USER_DEFAULT objectForKey:fob.uuid]];
    }else{
        [_fobNameLabel setText:fob.location];
    }
    [_signalImageView setImage:[fob currentSignalStrengthImage]];
    
    [_tempLabel setText:[NSString stringWithFormat:@"%.01f℃", lastReading.value.floatValue]];
    [_uuidLabel setText:[NSString stringWithFormat:@"UUID:%@",[fob.uuid substringFromIndex:20]]];
}
@end
