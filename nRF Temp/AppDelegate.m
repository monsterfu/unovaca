//
//  AppDelegate.m
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate
@synthesize window = _window;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if (![USER_DEFAULT stringForKey:KEY_USERNAME]) {
        //没有则创建一个
        NSString* personId = [NSString randomStr];
        PersonDetailInfo* _detailInfo = [PersonDetailInfo createPersonDetailInfoWithName:@"宝贝" personId:personId];
        _detailInfo.image = [UIImage imageNamed:@"default_head.png"];
        _detailInfo.birthday = [NSDate dateWithTimeIntervalSinceNow:-2*365*24*60*60];
        _detailInfo.weight = [NSNumber numberWithInteger:14];
        [USER_DEFAULT setObject:@"宝贝" forKey:KEY_USERNAME];
        [USER_DEFAULT setBool:YES forKey:KEY_BACKGROUND_OPEN];
        [USER_DEFAULT setObject:personId forKey:KEY_PERSONID];
        [USER_DEFAULT setObject:personId forKey:KEY_PERSONIDDF];
        [USER_DEFAULT setInteger:5 forKey:KEY_MOST_STR];
        
        NSError *error = nil;
        
        if (![_detailInfo.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [USER_DEFAULT setInteger:2014 forKey:KEY_SELECTED_YEAR];
    [USER_DEFAULT setInteger:7 forKey:KEY_SELECTED_MONTH];
    [USER_DEFAULT synchronize];
    
    [application setApplicationIconBadgeNumber:0];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示",nil)
                                                            message:[NSString stringWithFormat:@"%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
    }
    [application setApplicationIconBadgeNumber:0];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示",nil)
                                                            message:[NSString stringWithFormat:@"%@", notification.alertBody]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"知道了",nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
    }
    [application setApplicationIconBadgeNumber:0];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Saving all fobs...");
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Saving failed: %@", error);
    }
    if (!_scanTimer&&[USER_DEFAULT boolForKey:KEY_BACKGROUND_OPEN]) {
        [[ConnectionManager sharedInstance]startScanForFobsBackGround];
        _scanTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(backgroundScanBle) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_scanTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)backgroundScanBle
{
    NSLog(@"Saving all fobs...");
    
    [[ConnectionManager sharedInstance]startScanForFobsBackGround];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (_scanTimer) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Saving failed: %@", error);
    }
    [[ConnectionManager sharedInstance]startScanForFobs];
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Saving failed: %@", error);
    }
    [[ConnectionManager sharedInstance]startScanForFobs];
    
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TemperatureAppModels" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TemperatureAppModels.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) saveContext
{
    
}

@end
