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

- (void) startScanForFobsBackGround
{
    // Make sure we start scan from scratch
    if ([USER_DEFAULT objectForKey:KEY_SELECED_FOB]) {
        [self.cm stopScan];
        [self.cm scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"1809"]]
                                        options:@{
                                                  CBCentralManagerScanOptionSolicitedServiceUUIDsKey:@[
                                                          [CBUUID UUIDWithString:[USER_DEFAULT objectForKey:KEY_SELECED_FOB]]]}];
    }
    
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

//蓝色 1 9FA2778C-D2FD-40B8-0341-3197B672CB93
//蓝色 2 F37D9244-B190-C0FB-AFD5-9254D1B5C108
//白色UM F3D5A878-6C14-7A43-1B5A-7107652B65E4
//红色 1 5A2C44D4-2A77-D6A2-B3D9-897A66E9597E
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

    PersonDetailInfo* personInfo = [PersonDetailInfo PersonWithPersonId:[USER_DEFAULT stringForKey:KEY_PERSONID]];
    TemperatureFob *fob = [personInfo foundFobWithUUid:[peripheral.identifier UUIDString]];

    if (fob == nil && !self.acceptNewFobs)
    {
        return;
    }
    
    if (fob == nil)
    {
        fob = [personInfo createFobWithName:[peripheral name] UUid:[[peripheral identifier]UUIDString]];
        [self.delegate didDiscoverFob:fob];
    }
    
    [fob setSignalStrength:RSSI];
    
    [fob setBatteryLevelWithRawData:[serviceData objectForKey:[TemperatureFob batteryServiceUUID]]];
    
    if (![fob addReadingWithRawData:[serviceData objectForKey:[TemperatureFob thermometerServiceUUID]] person:personInfo])
    {
        NSLog(@"Threw away reading, too little time since last.");
    }
    
    if ([[[peripheral identifier]UUIDString] isEqualToString:[USER_DEFAULT stringForKey:KEY_SELECED_FOB]]) {
        
        uint32_t raw;
        NSData* rawData = [serviceData objectForKey:[TemperatureFob thermometerServiceUUID]];
        [rawData getBytes:&raw length:4];
        
        int8_t exponent = (raw & 0xFF000000) >> 24;
        int32_t mantissa = (raw & 0x00FFFFFF);
        if (mantissa & 0x00800000)
        {
            mantissa |= (0xFF000000);
        }
        
        CGFloat value = mantissa * pow(10.0, exponent);
        
        if (YES == [USER_DEFAULT boolForKey:KEY_WARNING_OPEN])
        {
            NSInteger savedTemp = [USER_DEFAULT integerForKey:KEY_MOST_STR] +37;
            NSLog(@"saveTemp ================================================>%d",savedTemp);
            if (value > savedTemp)
            {
                [[soundVibrateManager sharedInstance]playAlertSound];
                [[soundVibrateManager sharedInstance]vibrate];
                alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"目前体温已经超过%d℃报警值！",savedTemp] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        
        fob.active = YES;
        [self.delegate recentUpdateData:[serviceData objectForKey:[TemperatureFob thermometerServiceUUID]]];
    }
}
@end

