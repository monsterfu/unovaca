//
//  TemperatureCell.m
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import "TemperatureFobCell.h"

@implementation TemperatureFobCell

- (void) setFob:(TemperatureFob*) fob
{
    TemperatureReading *lastReading = [fob lastReading];
    [self.locationLabel setText:fob.location];

    [self.signalImage setImage:[fob currentSignalStrengthImage]];
    
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%.01f ℃", lastReading.value.floatValue]];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastReading.date];
    NSString *ageText;
    if (interval < 2*60.0)
    {
        ageText = @"刚刚更新";
    }
    else if (interval > 60.0*60.0)
    {
        ageText = @"很久之前更新";
    }
    else
    {
        ageText = [NSString stringWithFormat:@"%.f 分钟", (interval / 60)];
    }
    
    [self.ageLabel setText:ageText];
    
    [self.w setText:fob.idString];
}
@end
