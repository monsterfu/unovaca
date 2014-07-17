//
//  DetailViewController.m
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import "FobViewController.h"

@implementation FobViewController {
    
}
@synthesize fob = _fob;

- (void) setFob:(TemperatureFob *)fob
{
    if (fob != _fob)
    {
        _fob = fob;
        _fob.delegate = self;
    }
}

- (void)updateView
{
    // Update the user interface for the detail item.

    if (self.fob)
    {
        self.navigationItem.title = self.fob.location;
        self.idLabel.text = [NSString stringWithFormat:@"ID: %@", self.fob.idString];
        self.signalStrengthImage.image = self.fob.currentSignalStrengthImage;
        
        if (!self.locationField.isEditing)
        {
            self.locationField.text = self.fob.location;
        }
        [self.batteryView setBatteryLevel:self.fob.batteryLevel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    TemperatureReading* reading = [_readings objectAtIndex:0];
    _dateStr = [NSString stringWithFormat:@"%d%@%d%@",[reading.date month],NSLocalizedString(@"月",nil),[reading.date day],NSLocalizedString(@"日",nil)];
    
    NSString* titleStr = NSLocalizedString(@"宝贝体温记录",nil);
    self.title = [titleStr stringByAppendingString:[NSString stringWithFormat:@"(%@)",_dateStr]];
        
    [self updateView];
    [self.tableView reloadData];

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15.0, 0, 15.0)];
    }
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    UIImage* graphImg = [UIImage imageNamed:@"ic_titlebar_graph_history_normal"];
    UIBarButtonItem* graphButton = [[UIBarButtonItem alloc]initWithImage:[graphImg scaleToSize:graphImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(graphButtonPressed)];
    [graphButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.rightBarButtonItem = graphButton;
}
-(void)graphButtonPressed
{
    [self performSegueWithIdentifier:@"showGraph" sender:nil];
}
-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated
{
    if (self.fob)
    {
        self.fob.delegate = self;
        [self.tableView reloadData];
    }
}

- (IBAction) forgetFobPressed:(id)sender {
    UIAlertView* question = [[UIAlertView alloc] initWithTitle:@"Forget sensor"
                                                       message:[NSString stringWithFormat:@"Do you really want to remove the %@ sensor?", [self.fob location]]
                                                      delegate:self
                                             cancelButtonTitle:@"Keep sensor"
                                             otherButtonTitles:@"Forget sensor", nil];
    [question show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [_person deleteFob:self.fob];

        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.backgroundImage.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    else
    {
        self.backgroundImage.transform = CGAffineTransformMakeRotation(0.0);
    }
}

- (IBAction) nameChanged:(id)sender
{
    self.fob.location = self.locationField.text;
    [self updateView];

    // Make on-screen-keyboard disappear
    [sender resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showGraph"]) {
        [[segue destinationViewController] setFob:self.fob];
    }
    if ([segue.identifier isEqualToString:@"showGraph"])
    {
        NewGraphViewController* graphicController = (NewGraphViewController*)segue.destinationViewController;
        graphicController.readings = self.readings;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _readings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TemperatureReadingCell" forIndexPath:indexPath];
    
    TemperatureReading *reading = [_readings objectAtIndex:_readings.count - [indexPath row] -1];
    [cell.textLabel setText:[NSString stringWithFormat:@"%.01f ℃", [reading.value floatValue]]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setDoesRelativeDateFormatting:YES];

    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setTimeStyle:NSDateFormatterShortStyle];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@, %@", [df stringFromDate:[reading date]], [tf stringFromDate:[reading date]]]];
    
    return cell;
}
-(void) recentUpdateData:(NSData*)rawData
{
    
}
- (void) didUpdateData:(TemperatureFob *)fob
{
    if (fob == self.fob)
    {
        [self updateView];
        [self.tableView reloadData];
    }
}


@end
