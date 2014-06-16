//
//  PersonDetailInfo.h
//  nRF Temp
//
//  Created by Monster on 14-4-9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TemperatureFob.h"

@interface PersonDetailInfo : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * blood;
@property (nonatomic, retain) NSNumber * high;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * weight;

+ (PersonDetailInfo *) PersonWithName:(NSString *) name;
+ (PersonDetailInfo *) createPersonDetailInfoWithName:(NSString *)name;
+ (NSMutableArray *) allPersonDetail;
+ (BOOL) deletePerson:(PersonDetailInfo *)person;

- (BOOL)addFob:(TemperatureFob*)fob;
- (TemperatureFob *) foundFobWithName:(NSString*)name;
- (TemperatureFob *) foundFobWithUUid:(NSString*)uuid;
- (TemperatureFob *) createFobWithName:(NSString *)name UUid:(NSString*)uuid;
- (NSArray *) allFoundFobs;
- (NSArray *) allStoredFobs;

- (void) deleteStoredFobs;
- (void) deleteFoundFobs;
- (BOOL) deleteFob:(TemperatureFob *) fob;
@end


@interface PersonDetailInfo (CoreDataGeneratedAccessors)

- (void)addFobingsObject:(TemperatureFob *)value;
- (void)removeFobingsObject:(TemperatureFob *)value;
- (void)addFobings:(NSSet *)values;
- (void)removeFobings:(NSSet *)values;

@end