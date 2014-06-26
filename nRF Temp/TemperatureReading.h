//
//  TemperatureReading.h
//  nRF Temp
//
//  Created by Ole Morten on 10/18/12.
//
//

#import <Foundation/Foundation.h>

@class TemperatureFob;
@class PersonDetailInfo;

@interface TemperatureReading : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) TemperatureFob *fob;
@property (nonatomic, retain) PersonDetailInfo *person;

- (void) setRawValue:(NSData *) rawData;

@end
