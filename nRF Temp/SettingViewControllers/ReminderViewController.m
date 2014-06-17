/*
 sssss
*/

#import "ReminderViewController.h"

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
        
        eventViewController.reminderModel = [EventReminderModel foundEventReminderModelWithIndex:self.tableView.indexPathForSelectedRow.row];
    }else if ([[segue identifier] isEqualToString:@"addEventViewController"])
    {
        ReminderViewDetailController* eventViewController = (ReminderViewDetailController *)[segue destinationViewController];
        
        eventViewController.reminderModel = [EventReminderModel createEventReminderModelWithIndex:_allEventReminderModelArray.count content:nil date:[NSDate date] repeat:YES];
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
    return _eventCell;
}

#pragma mark -
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender
{
    [self performSegueWithIdentifier:@"addEventViewController" sender:nil];
}
@end