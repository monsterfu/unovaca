//
//  ConnectionManager.h
//  ProximityApp
//
//  Copyright (c) 2012 Nordic Semiconductor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemperatureFob.h"
#import "TemperatureReading.h"
#import "soundVibrateManager.h"

@protocol ConnectionManagerDelegate 
- (void) isBluetoothEnabled:(bool) enabled;
- (void) didDiscoverFob:(TemperatureFob*) fob;
-(void) recentUpdateData:(NSData*)rawData;
@end

@interface ConnectionManager : NSObject <CBCentralManagerDelegate>
@property BOOL acceptNewFobs;
@property id<ConnectionManagerDelegate> delegate;

+ (ConnectionManager*) sharedInstance;

- (void) startScanForFobs;
- (void) stopScanForFobs;

@end
