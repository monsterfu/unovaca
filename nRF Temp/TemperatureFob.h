//
//  TemperatureFob.h
//  nRF Temp
//
//  Created by Ole Morten on 10/18/12.
//
//

#import <Foundation/Foundation.h>

#import "TemperatureReading.h"
#import "PublicDefine.h"

@protocol TemperatureFobDelegate
- (void) didUpdateData:(TemperatureFob *) fob;
@end

@interface TemperatureFob : NSManagedObject
@property (nonatomic, retain) id<TemperatureFobDelegate> delegate;

@property (nonatomic, retain) NSNumber *batteryLevel;
@property (nonatomic, retain) NSNumber *temperature;
@property (nonatomic, retain) NSString *idString;
@property (assign) BOOL isSaved;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSNumber *signalStrength;
@property (nonatomic, retain) NSSet *readings;

@property (nonatomic, assign) BOOL active;


+ (CBUUID *) batteryServiceUUID;
+ (CBUUID *) thermometerServiceUUID;

- (UIImage *) currentSignalStrengthImage;
- (UIImage *) currentBatteryImage;

- (void) setBatteryLevelWithRawData:(NSData *) rawData;
- (BOOL) addReadingWithRawData:(NSData *)rawData;

- (TemperatureReading *) lastReading;
- (NSArray *) lastReadings:(NSUInteger) number;
- (NSArray *) lastReadingsSince:(NSUInteger) minutes;
- (NSArray *) lastReadingsDay:(NSDate*)day;
- (NSArray *) lastReadingsMonth:(NSDate*)month;
@end

@interface TemperatureFob (CoreDataGeneratedAccessors)

- (void)addReadingsObject:(NSManagedObject *)value;
- (void)removeReadingsObject:(NSManagedObject *)value;
- (void)addReadings:(NSSet *)values;
- (void)removeReadings:(NSSet *)values;

@end