/*
     File: RootViewController.m
 Abstract: Table view controller that displays events occuring within the next 24 hours. Prompts a user
 for access to their Calendar, then updates its UI according to their response.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "ReminderViewController.h"

@interface ReminderViewController () <EKEventEditViewDelegate>
// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

// Used to add events to Calendar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@end


@implementation ReminderViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize the event store  
	self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
	self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    // The Add button is initially disabled
    self.addButton.enabled = NO;
    
//    
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    
//    // Create a new event
//    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
//    
//    // Create NSDates to hold the start and end date
//    NSDate *startDate = [[NSDate alloc] init];
//    NSDate *endDate  = [[NSDate alloc] initWithTimeIntervalSinceNow:300];
//    
//    // Set properties of the new event object
//    event.title     = @"胡峰";
//    event.startDate = startDate;
//    event.endDate   = endDate;
//    event.allDay = NO;
//    NSMutableArray *myAlarmsArray = [[NSMutableArray alloc] init];
//    
//    EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-60];// 1 minutes
//    EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:-86400];// 1 Day
//    
//    [myAlarmsArray addObject:alarm1];
//    [myAlarmsArray addObject:alarm2];
//    
//    event.alarms = myAlarmsArray;
//    // set event's calendar to the default calendar
//    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
//    
//    // Create an NSError pointer
//    NSError *err;
//    
//    // Save the event
//    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
//    
//    // Test for errors
//    if (err ==noErr) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"提醒时间创建"
//                              message:@"How about that?"
//                              delegate:nil
//                              cancelButtonTitle:@"Okay"
//                              otherButtonTitles:nil];
//        [alert show];
//    }
    
//    NSString* startDate = [_parameters objectForKey:@"startDate"];
//    NSString* endDate = [_parameters objectForKey:@"endDate"];
//    NSString* title = [_parameters objectForKey:@"title"];
//    NSString* location = [_parameters objectForKey:@"location"];
//    NSDate* start = [[NSDate alloc]initWithString: startDate];
//    NSDate* end = [[NSDate alloc]initWithString: endDate];
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    EKCalendar *cal = [eventStore defaultCalendarForNewEvents]; // Get the User's default calendar.  You could create a new calendar though for your team
//    
//    // Setup the Event
//    EKEvent *event = [EKEvent eventWithEventStore: eventStore];
//    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-300];
//    [event addAlarm: alarm];
//    [event setCalendar: cal];
//    [event setTitle: title];
//    [event setStartDate: start];
//    [event setEndDate: end];
//    [event setLocation: location];
//    
//    
//    //Setup a new Event View Controller
//    viewController = [[EKEventEditViewController alloc] initWithNibName:nil bundle: nil];
//    viewController.eventStore = eventStore;
//    viewController.event = event;
//    UINavigationController *controller = [[NSClassFromString(@"NKBridge") sharedInstance] navigationControllerForPage:@"ergebnis.html"]; //Replace main.html with the page you will be calling the calendar from
//    
//    [controller presentModalViewController: viewController animated: YES];
//    viewController.editViewDelegate=self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Check whether we are authorized to access Calendar
    [self checkEventStoreAccessForCalendar];
}


// This method is called when the user selects an event in the table view. It configures the destination
// event view controller with this event.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEventViewController"])
    {
        // Configure the destination event view controller
        EKEventViewController* eventViewController = (EKEventViewController *)[segue destinationViewController];
        // Fetch the index path associated with the selected event
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Set the view controller to display the selected event
        eventViewController.event = [self.eventsList objectAtIndex:indexPath.row];
        
        // Allow event editing
        eventViewController.allowsEditing = YES;
        eventViewController.allowsCalendarPreview = YES;
    }
}


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.eventsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    // Get the event at the row selected and display its title
    cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
    return cell;
}


#pragma mark -
#pragma mark Access Calendar

// Check the authorization status of our application for Calendar 
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];    
 
    switch (status)
    {
        // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
        // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
        // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
         if (granted)
         {
             ReminderViewController * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
             // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    // Let's get the default calendar associated with our event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    // Enable the Add button  
    self.addButton.enabled = YES;
    // Fetch all events happening in the next 24 hours and put them into eventsList
    self.eventsList = [self fetchEvents];
    // Update the UI with the above events
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Fetch events

// Fetch all events happening in the next 24 hours 
- (NSMutableArray *)fetchEvents
{
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
	
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
	// We will only search the default calendar for our events
	NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
  
    // Create the predicate
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
	
	// Fetch all events that match the predicate
	NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
	return events;
}


#pragma mark -
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender
{
	// Create an instance of EKEventEditViewController 
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
	
	// Set addController's event store to the current event store
	addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    [self presentViewController:addController animated:YES completion:nil];
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
		  didCompleteWithAction:(EKEventEditViewAction)action
{
    ReminderViewController * __weak weakSelf = self;
	// Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Re-fetch all events happening in the next 24 hours
                 weakSelf.eventsList = [self fetchEvents];
                 // Update the UI with the above events
                 [weakSelf.tableView reloadData];
             });
         }
     }];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
	return self.defaultCalendar;
}

@end