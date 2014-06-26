/*
 sssss
*/

#import "ReminderViewController.h"
#import "AppDelegate.h"

@interface ReminderViewController ()

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
    self.addButton.enabled = NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    _allEventReminderModelArray = [EventReminderModel allEventReminderModel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eventReminderChanged) name:NSNotificationCenter_EventReminderChanged object:nil];
    _allEventNoticationArray = [NSMutableArray array];
    
    for (EventReminderModel* model in _allEventReminderModelArray) {
        _localNotice = [[UILocalNotification alloc]init];
        _localNotice.applicationIconBadgeNumber = 1;
        _localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:100];//model.time;
        _localNotice.timeZone = [NSTimeZone defaultTimeZone];
        _localNotice.soundName = @"4031.wav";
        if (model.repeat) {
            _localNotice.repeatInterval = NSDayCalendarUnit;
        }else{
            _localNotice.repeatInterval = NSYearCalendarUnit;
        }
        _localNotice.alertBody = model.eventContent;
        
        [_allEventNoticationArray addObject:_localNotice];
    }
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenter_EventReminderChanged object:nil];
}
// This method is called when the user selects an event in the table view. It configures the destination
// event view controller with this event.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEventViewController"])
    {
        ReminderViewDetailController* eventViewController = (ReminderViewDetailController *)[segue destinationViewController];
        eventReminderCell* cell = (eventReminderCell*)sender;
        eventViewController.reminderModel = cell.eventReminderModel;
        eventViewController.isAdd = NO;
        _localNotice = [_allEventNoticationArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [[UIApplication sharedApplication]cancelLocalNotification:_localNotice];
        eventViewController.localNotice = [_allEventNoticationArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
    }else if ([[segue identifier] isEqualToString:@"addEventViewController"])
    {
        ReminderViewDetailController* eventViewController = (ReminderViewDetailController *)[segue destinationViewController];
        eventViewController.reminderModel = [EventReminderModel createEventReminderModelWithIndex:_allEventReminderModelArray.count content:nil date:[NSDate date] repeat:YES];
        eventViewController.isAdd = YES;
        
        _localNotice = [[UILocalNotification alloc] init];
        _localNotice.fireDate = [NSDate date];
        _localNotice.timeZone = [NSTimeZone defaultTimeZone];
        _localNotice.soundName = @"4031.wav";
        _localNotice.repeatInterval = NSDayCalendarUnit;
        
        eventViewController.localNotice = _localNotice;
        [_allEventNoticationArray addObject:_localNotice];
    }
}
#pragma mark -
#pragma mark - NSNotificationCenter
-(void)eventReminderChanged
{
    _allEventReminderModelArray = [EventReminderModel allEventReminderModel];    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _allEventReminderModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	_eventCell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    _eventCell.eventReminderModel = [_allEventReminderModelArray objectAtIndex:indexPath.row];
    _eventCell.delegate = self;
    return _eventCell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [EventReminderModel deleteEventReminder:[_allEventReminderModelArray objectAtIndex:indexPath.row]];
        [_allEventReminderModelArray removeObjectAtIndex:indexPath.row];
        _localNotice = [_allEventNoticationArray objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication]cancelLocalNotification:_localNotice];
        [_allEventNoticationArray removeObject:_localNotice];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
#pragma mark -
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender
{
    [self performSegueWithIdentifier:@"addEventViewController" sender:nil];
}

#pragma mark -
#pragma mark eventReminderCellDelegate

-(void)switchChanged:(BOOL)on index:(NSUInteger)index
{
    if ([_allEventNoticationArray count] > index) {
        _localNotice = [_allEventNoticationArray objectAtIndex:index];
        
        EventReminderModel * eventReminderModel = [_allEventReminderModelArray objectAtIndex:index];
        if (on) {
            eventReminderModel.open = [NSNumber numberWithBool:YES];
            [[UIApplication sharedApplication] scheduleLocalNotification:_localNotice];
        }else{
            eventReminderModel.open = [NSNumber numberWithBool:NO];
            [[UIApplication sharedApplication]cancelLocalNotification:_localNotice];
        }
        
        
        NSManagedObjectContext *managedObjectContext = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
        NSManagedObjectContext *context = eventReminderModel.managedObjectContext;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}
@end