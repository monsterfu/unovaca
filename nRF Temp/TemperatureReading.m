//
//  TemperatureReading.m
//  nRF Temp
//
//  Created by Ole Morten on 10/18/12.
//
//

#import "TemperatureReading.h"
#import "TemperatureFob.h"
#import "soundVibrateManager.h"
#import "PublicDefine.h"

@implementation TemperatureReading

@dynamic date;
@dynamic value;
@dynamic fob;

- (void) setRawValue:(NSData *) rawData
{
    uint32_t raw;
    [rawData getBytes:&raw length:4];
    
    int8_t exponent = (raw & 0xFF000000) >> 24;
    int32_t mantissa = (raw & 0x00FFFFFF);
    if (mantissa & 0x00800000)
    {
        mantissa |= (0xFF000000);
    }
    
    NSLog(@"Raw value: %@, %x, %x, %x，[NSNumber numberWithFloat:mantissa * pow(10.0, exponent)]：%f", rawData, raw, exponent, mantissa,mantissa * pow(10.0, exponent));
    
    self.value = [NSNumber numberWithFloat:mantissa * pow(10.0, exponent)];
}

@end
