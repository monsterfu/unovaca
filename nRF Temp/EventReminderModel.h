//
//  EventReminderModel.h
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventReminderModel : NSManagedObject

@property (nonatomic, retain) NSString * eventContent;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * open;

+ (BOOL) deleteEventReminder:(EventReminderModel *)EventReminder;
+ (NSMutableArray *) allEventReminderModel;
+ (EventReminderModel *) foundEventReminderModelWithIndex:(NSUInteger)index;
+ (EventReminderModel *) createEventReminderModelWithIndex:(NSUInteger)index content:(NSString *)content date:(NSDate*)date repeat:(BOOL)repeat;
@end
