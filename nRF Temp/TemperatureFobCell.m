//
//  TemperatureCell.m
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import "TemperatureFobCell.h"

@implementation TemperatureFobCell

- (IBAction)selectedButtonTouch:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedFobButtonTouched:)]) {
        [self.delegate selectedFobButtonTouched:_fob];
    }
}

- (void) setFob:(TemperatureFob*) fob
{
    _fob = fob;
    TemperatureReading *lastReading = [fob lastReading];
    if ([USER_DEFAULT objectForKey:fob.uuid]) {
        [_nameLabel setText:[USER_DEFAULT objectForKey:fob.uuid]];
    }else{
        [_nameLabel setText:fob.location];
    }
    [_tempLabel setText:[NSString stringWithFormat:@"%.01f ℃", lastReading.value.floatValue]];
    NSDate* date = [NSDate dateWithTimeInterval:8*4*60*60 sinceDate:[lastReading date]];
    NSString* dateStr = [date.description substringToIndex:19];
//    NSString* dateStr = [NSString stringWithFormat:@"(%@)",[lastReading.date.description substringToIndex:19]];
    [_dateTimeLabel setText:dateStr];
    [_signalImageView setImage:[fob currentSignalStrengthImage]];
    
    [_selectedButton setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
    if ([[USER_DEFAULT objectForKey:KEY_SELECED_FOB] isEqualToString:fob.uuid]) {
        [_selectedButton setImage:[UIImage imageNamed:@"btn_radio_on.png"] forState:UIControlStateNormal];
    }
}
@end
