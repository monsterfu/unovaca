//
//  TemperatureFob.m
//  nRF Temp
//
//  Created by Ole Morten on 10/18/12.
//
//

#import "TemperatureFob.h"

#import "AppDelegate.h"

@implementation TemperatureFob

@dynamic batteryLevel;
@dynamic idString;
@dynamic isSaved;
@dynamic location;
@dynamic readings;
@dynamic temperature;

@synthesize signalStrength = _signalStrength;

@synthesize delegate = _delegate;

+ (CBUUID *) batteryServiceUUID
{
    return [CBUUID UUIDWithString:@"180F"];
}

+ (CBUUID *) thermometerServiceUUID
{
    return [CBUUID UUIDWithString:@"1809"];
}




- (void) setBatteryLevelWithRawData:(NSData *)rawData
{
    uint8_t value;
    [rawData getBytes:&value length:1];
    self.batteryLevel = [NSNumber numberWithUnsignedShort:value];
    
    [self.delegate didUpdateData:self];
}

- (BOOL) addReadingWithRawData:(NSData *)rawData
{
    NSDate *now = [NSDate date];
    NSInteger index = [USER_DEFAULT integerForKey:KEY_GAPTIMER_STR];
    CGFloat time = 0;
    switch (index) {
        case 0:
            time = 5;
            break;
        case 1:
            time = 10;
            break;
        case 2:
            time = 5*60;
            break;
        case 3:
            time = 10*60;
            break;
        case 4:
            time = 15*60;
            break;
        case 5:
            time = 30*60;
            break;
        case 6:
            time = 60*60;
            break;
        default:
            break;
    }
    
    
//    if ([now timeIntervalSinceDate:[self.lastReading date]] < time)
//    {
//        return false;
//    }
//    
//    uint32_t raw;
//    [rawData getBytes:&raw length:4];
//    
//    int8_t exponent = (raw & 0xFF000000) >> 24;
//    int32_t mantissa = (raw & 0x00FFFFFF);
//    if (mantissa & 0x00800000)
//    {
//        mantissa |= (0xFF000000);
//    }
//    
//    CGFloat value = mantissa * pow(10.0, exponent);
//    if (value < 35.0f || value > 42.0f) {
//        return NO;
//    }
    
    TemperatureReading *reading = (TemperatureReading *) [NSEntityDescription insertNewObjectForEntityForName:@"TemperatureReading" inManagedObjectContext:self.managedObjectContext];
    [reading setDate:[NSDate date]];
    [reading setRawValue:rawData];
    [reading setFob:self];
    
    [self addReadingsObject:reading];
    
    [self.delegate didUpdateData:self];
    
    return true;
}

- (UIImage *) currentBatteryImage
{
    NSString *imageName;
    if (self.batteryLevel.intValue > 80)
        imageName = @"battery_100";
    else if (self.batteryLevel.intValue > 60)
        imageName = @"battery_80";
    else if (self.batteryLevel.intValue > 40)
        imageName = @"battery_60";
    else if (self.batteryLevel.intValue > 20)
        imageName = @"battery_40";
    else if(self.batteryLevel.intValue > 10)
        imageName = @"battery_20";
    else
        imageName = @"battery_10";
    
    return [UIImage imageNamed:imageName];
}

- (UIImage *) currentSignalStrengthImage
{
    NSString *imageName;
    if (self.signalStrength.floatValue > -40.0)
        imageName = @"ic_signal_3.png";
    else if (self.signalStrength.floatValue > -60.0)
        imageName = @"ic_signal_2.png";
    else if (self.signalStrength.floatValue > -100.0)
        imageName = @"ic_signal_1.png";
    else
        imageName = @"ic_signal_0.png";
    UIImage* image = [UIImage imageNamed:imageName];
    return [image scaleToSize:image size:CGSizeMake(30, 30)];
}

- (TemperatureReading *) lastReading
{
    NSArray *readings = [self lastReadings:0];
    if ([readings count] > 0)
    {
        return [readings objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

- (NSArray *) lastReadings:(NSUInteger) number
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureReading"];
    [request setFetchLimit:number];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"fob.idString LIKE %@", self.idString]];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}

- (NSArray *) lastReadingsSince:(NSUInteger) minutes
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureReading"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSDate *startTime = [NSDate dateWithTimeIntervalSinceNow:-(minutes*60.0)];
    [request setPredicate:[NSPredicate predicateWithFormat:@"fob.idString LIKE %@ AND date >= %@", self.idString, startTime]];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
    
}
                                   
- (NSArray *) lastReadingsDay:(NSDate*)day
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureReading"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSLog(@"startTime , endTime:%@",day);
    
    NSDate* startTime = [NSDate currentDayStartTime:day];
    NSDate* endTime = [NSDate currentDayEndTime:day];
    
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"fob.idString LIKE %@ AND date >= %@ AND date <= %@", self.idString,startTime, endTime]];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}

- (NSArray *) lastReadingsMonth:(NSDate*)month
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureReading"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    NSDate *startTime = month;
    [request setPredicate:[NSPredicate predicateWithFormat:@"fob.idString LIKE %@ AND date >= %@", self.idString, startTime]];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}
@end
