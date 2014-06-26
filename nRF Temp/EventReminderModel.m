//
//  EventReminderModel.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "EventReminderModel.h"
#import "AppDelegate.h"

@implementation EventReminderModel

@dynamic eventContent;
@dynamic time;
@dynamic repeat;
@dynamic index;

+ (BOOL) deleteEventReminder:(EventReminderModel *)EventReminder
{
    NSManagedObjectContext *moc = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [moc deleteObject:EventReminder];
    
    NSError *error;
    [moc save:&error];
    if (error)
    {
        NSLog(@"Error deleting fob: %@", error);
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSMutableArray *) allEventReminderModel
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSArray *array = [delegate.managedObjectContext executeFetchRequest:[delegate.managedObjectModel fetchRequestTemplateForName:@"EventReminderFobs"] error:&error];
    if (error)
    {
        NSLog(@"Fetching stored EventReminderModel failed. Error: %@", error);
    }
    return [NSMutableArray arrayWithArray:array];
}

+ (EventReminderModel *) foundEventReminderModelWithIndex:(NSUInteger)index
{
    NSManagedObjectContext *managedObjectContext = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EventReminderModel"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"index == %d", index]];
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
}

+ (EventReminderModel *) createEventReminderModelWithIndex:(NSUInteger)index content:(NSString *)content date:(NSDate*)date repeat:(BOOL)repeat
{
    NSManagedObjectContext *managedObjectContext = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    EventReminderModel *eventReminderModel = (EventReminderModel *) [NSEntityDescription insertNewObjectForEntityForName:@"EventReminderModel" inManagedObjectContext:managedObjectContext];
    eventReminderModel.index = [NSNumber numberWithInteger:index];
    eventReminderModel.eventContent = content;
    eventReminderModel.time = date;
    eventReminderModel.repeat = [NSNumber numberWithBool:repeat];
    eventReminderModel.open = [NSNumber numberWithBool:YES];
    return eventReminderModel;
}
@end
