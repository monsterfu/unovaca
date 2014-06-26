//
//  AppDelegate.h
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import <UIKit/UIKit.h>

#import "ListViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimer* _scanTimer;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *) applicationDocumentsDirectory;
- (void) saveContext;
@end
