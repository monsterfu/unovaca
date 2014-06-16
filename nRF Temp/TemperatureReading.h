//
//  TemperatureReading.h
//  nRF Temp
//
//  Created by Ole Morten on 10/18/12.
//
//

#import <Foundation/Foundation.h>

@class TemperatureFob;

@interface TemperatureReading : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) TemperatureFob *fob;

- (void) setRawValue:(NSData *) rawData;

@end
