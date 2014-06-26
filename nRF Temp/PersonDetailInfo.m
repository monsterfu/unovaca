//
//  PersonDetailInfo.m
//  nRF Temp
//
//  Created by Monster on 14-4-9.
//
//

#import "PersonDetailInfo.h"
#import "AppDelegate.h"

@implementation PersonDetailInfo

@dynamic birthday;
@dynamic blood;
@dynamic high;
@dynamic image;
@dynamic name;
@dynamic sex;
@dynamic weight;
@dynamic personId;

#pragma mark - Person
+ (PersonDetailInfo *) PersonWithPersonId:(NSString *)personId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PersonDetailInfo"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"personId LIKE %@", personId]];
    NSManagedObjectContext *moc = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    if ([array count] == 1)
    {
        return [array objectAtIndex:0];
    }
    else if (error)
    {
        NSLog(@"Fetching failed. Error: %@. Count: %d.", error, [array count]);
    }
    return nil;
}

+ (PersonDetailInfo *) createPersonDetailInfoWithName:(NSString *)name personId:(NSString*)personId
{
    NSManagedObjectContext *managedObjectContext = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    
    PersonDetailInfo *personDetailInfo = (PersonDetailInfo *) [NSEntityDescription insertNewObjectForEntityForName:@"PersonDetailInfo" inManagedObjectContext:managedObjectContext];
    personDetailInfo.name = name;
    personDetailInfo.personId = personId;
    return personDetailInfo;
}


+ (NSMutableArray *) allPersonDetail
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSArray *array = [delegate.managedObjectContext executeFetchRequest:[delegate.managedObjectModel fetchRequestTemplateForName:@"PersonFobs"] error:&error];
    if (error)
    {
        NSLog(@"Fetching stored fobs failed. Error: %@", error);
    }
    return [NSMutableArray arrayWithArray:array];
}


- (NSArray *) UsersReadings:(NSString*) name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureReading"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"fob.idString LIKE %@", self.name]];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}

+ (void) deleteAllPerson
{
    for (PersonDetailInfo *person in [self allPersonDetail])
    {
        [self deletePerson:person];
    }
}

+ (BOOL) deletePerson:(PersonDetailInfo *)person
{
    NSManagedObjectContext *moc = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [moc deleteObject:person];
    
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
- (BOOL)addFob:(TemperatureFob*)fob
{
    [self addFobingsObject:fob];
    
    return true;
}





#pragma mark fob 

- (void) deleteFoundFobs
{
    for (TemperatureFob *f in [self allFoundFobsPerson])
    {
        [self deleteFob:f];
    }
}
- (void) deleteStoredFobs
{
    for (TemperatureFob *f in [self allStoredFobs])
    {
        [self deleteFob:f];
    }
}


- (BOOL) deleteFob:(TemperatureFob *) fob
{
    [self.managedObjectContext deleteObject:fob];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"Error deleting fob: %@", error);
        return false;
    }
    else
    {
        return true;
    }
}

- (TemperatureFob *) foundFobWithUUid:(NSString*)uuid
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureFob"];
    [request setFetchLimit:1];
    [request setPredicate:[NSPredicate predicateWithFormat:@"uuid LIKE %@ AND accordings.name LIKE %@", uuid, self.name]];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
}

- (TemperatureFob *) foundFobWithUUid:(NSString*)uuid isSave:(BOOL)save
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureFob"];
    [request setFetchLimit:1];
    if (save) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"uuid LIKE %@ AND accordings.name LIKE %@ AND isSaved == YES", uuid, self.name]];
    }else{
        [request setPredicate:[NSPredicate predicateWithFormat:@"uuid LIKE %@ AND accordings.name LIKE %@ AND isSaved == NO", uuid, self.name]];
    }
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
}

- (TemperatureFob *) createFobWithName:(NSString *)name UUid:(NSString*)uuid;
{
    TemperatureFob *fob = (TemperatureFob *) [NSEntityDescription insertNewObjectForEntityForName:@"TemperatureFob" inManagedObjectContext:self.managedObjectContext];
    fob.idString = name;
    fob.isSaved = NO;
    
    // Set default name and location to known value.
    fob.location = name;//@"unova";
    fob.uuid = uuid;
    [self addFobingsObject:fob];
    return fob;
}

- (NSArray *) allFoundFobsPerson
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureFob"];
    NSError *error;
    [request setPredicate:[NSPredicate predicateWithFormat:@"accordings.name LIKE %@ AND isSaved == NO", self.name]];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}
- (NSArray *) allStoredFobsPerson
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureFob"];
    NSError *error;
    [request setPredicate:[NSPredicate predicateWithFormat:@"accordings.name LIKE %@ AND isSaved == YES", self.name]];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}

- (NSArray *) allFoundFobs
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureFob"];
    NSError *error;
    [request setPredicate:[NSPredicate predicateWithFormat:@"isSaved == NO"]];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}
- (NSArray *) allStoredFobs
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TemperatureFob"];
    NSError *error;
    [request setPredicate:[NSPredicate predicateWithFormat:@"isSaved == YES"]];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Fetching readings failed: %@", error);
    }
    return array;
}
@end
