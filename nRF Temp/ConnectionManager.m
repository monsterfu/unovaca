//
//  ConnectionManager.m
//  ProximityApp
//
//  Copyright (c) 2012 Nordic Semiconductor. All rights reserved.
//

#import "ConnectionManager.h"

#import "AppDelegate.h"

@interface ConnectionManager ()
@property CBCentralManager *cm;
@end

@implementation ConnectionManager
@synthesize cm = _cm;
@synthesize acceptNewFobs = _acceptNewFobs;
@synthesize delegate = _delegate;

static ConnectionManager *sharedConnectionManager;

+ (ConnectionManager*) sharedInstance
{
    if (sharedConnectionManager == nil)
    {
        sharedConnectionManager = [[ConnectionManager alloc] initWithDelegate:nil];
    }
    return sharedConnectionManager;
}

- (ConnectionManager*) initWithDelegate:(id<ConnectionManagerDelegate>) delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        _acceptNewFobs = NO;
        
        _cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void) startScanForFobs
{
    NSDictionary* scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    // Make sure we start scan from scratch
    [self.cm stopScan];
    
    [self.cm scanForPeripheralsWithServices:nil options:scanOptions];
}

- (void) stopScanForFobs
{
    [self.cm stopScan];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Central manager did update state.");
    if ([central state] == CBCentralManagerStatePoweredOn)
    {
        [_delegate isBluetoothEnabled:YES];        
    }
    else 
    {
        [_delegate isBluetoothEnabled:NO];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"[peripheral name]:%@",[peripheral name]);
}
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSDictionary *serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceData"];
    if (!serviceData ||
        (![serviceData objectForKey:[TemperatureFob thermometerServiceUUID]] ||
         ![serviceData objectForKey:[TemperatureFob batteryServiceUUID]]))
    {
//        NSLog(@"Discovered unknown device, %@", [peripheral name]);
        return;
    }
    
    NSLog(@"Discovered peripheral, name %@, data: %@, RSSI: %f, peripheral.identifier:%@", [peripheral name], advertisementData, RSSI.floatValue,peripheral.identifier);

    PersonDetailInfo* personInfo = [PersonDetailInfo PersonWithName:[USER_DEFAULT stringForKey:KEY_USERNAME]];
    TemperatureFob *fob = [personInfo foundFobWithName:peripheral.name];

    if (fob == nil && !self.acceptNewFobs)
    {
        return;
    }
    
    if (fob == nil)
    {
        fob = [personInfo createFobWithName:[peripheral name]];
        [self.delegate didDiscoverFob:fob];
    }
    
    fob.active = YES;
    
    [fob setSignalStrength:RSSI];
    
    [fob setBatteryLevelWithRawData:[serviceData objectForKey:[TemperatureFob batteryServiceUUID]]];
    
    if (![fob addReadingWithRawData:[serviceData objectForKey:[TemperatureFob thermometerServiceUUID]]])
    {
        NSLog(@"Threw away reading, too little time since last.");
    }
    
    if ([peripheral.name isEqualToString:[USER_DEFAULT stringForKey:KEY_FOBNAME]]) {
        [self.delegate recentUpdateData:[serviceData objectForKey:[TemperatureFob thermometerServiceUUID]]];
    }
}
@end

