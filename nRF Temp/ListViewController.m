//
//  MasterViewController.m
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import "ListViewController.h"
#import "AppDelegate.h"

#define STORED_FOBS_SECTION 0
#define FOUND_FOBS_SECTION 1


@interface ListViewController ()
//@property NSArray *storedFobs;
@property NSArray *foundFobs;
@property NSTimer *updateTimer;
@property UIBarButtonItem *addButton;
@property UIBarButtonItem *stopButton;
@property UIBarButtonItem *cancelButton;
@property BOOL showNewFobSection;
@end

@implementation ListViewController
//@synthesize storedFobs = _storedFobs;
@synthesize foundFobs = _foundFobs;
@synthesize showNewFobSection = _showNewFobSection;

@synthesize updateTimer = _updateTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
    
   // self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    UIImage* addImg = [UIImage imageNamed:@"ic_titlebar_add_kid_normal"];
    _addButton = [[UIBarButtonItem alloc]initWithImage:[addImg scaleToSize:addImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed)];
    [_addButton setImageInsets:UIEdgeInsetsMake(3, 0, 3, 6)];
    self.navigationItem.rightBarButtonItem = _addButton;
    
    UIImage* stopImg = [UIImage imageNamed:@"umeng_update_close_bg_normal"];
    _stopButton = [[UIBarButtonItem alloc]initWithImage:[stopImg scaleToSize:stopImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    [_stopButton setImageInsets:UIEdgeInsetsMake(3, 0, 3, 6)];
    
        
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
//    if (![self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
//    {
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:157/255.0 blue:222/255.0 alpha:1.0];
//        self.navigationController.navigationBar.translucent = NO;
//    }
    
//    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BLUETOOTH-SMART-LOGO-white.png"]];
//    self.navigationItem.titleView = logo;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10.0, 0, 10.0)];
    }
    
    [[ConnectionManager sharedInstance] setDelegate:self];
    
//    UIBarButtonItem* backButtom = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backhl.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
////    [backButtom setImageInsets:UIEdgeInsetsMake(6, 0, 6, 10)];
//    self.navigationItem.leftBarButtonItem = backButtom;
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[ConnectionManager sharedInstance] startScanForFobs];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateTimerCallback) userInfo:nil repeats:YES];
    
    _fobArray = [NSMutableArray arrayWithArray:[_detailInfo allStoredFobsPerson]];
    
    for (TemperatureFob *fob in _fobArray)
    {
        fob.delegate = self;
        fob.signalStrength = [NSNumber numberWithFloat:0.0f];
    }
    [self reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.updateTimer invalidate];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        TemperatureFob *fob = [self.storedFobs objectAtIndex:[indexPath row]];

        [self cancelButtonPressed];

//        [[segue destinationViewController] setFob:fob];
        
    }else if([[segue identifier] isEqualToString:@"deviceDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TemperatureFob *fob = [_fobArray objectAtIndex:[indexPath row]];
        [self cancelButtonPressed];
        
        if (fob) {
            [[segue destinationViewController] setFob:fob];
        }
        
        [[segue destinationViewController] setPerson:_detailInfo];
        
    }
}

- (void) isBluetoothEnabled:(bool)enabled
{
    NSLog(@"Is Bluetooth enabled: %d", enabled);
    if (enabled)
    {
        [[ConnectionManager sharedInstance] startScanForFobs];
    }
}

- (void) reloadData
{
//    self.storedFobs = [TemperatureFob allStoredFobs];
    self.foundFobs = [_detailInfo allFoundFobsPerson];
    
//    self.storedFobs = [self.storedFobs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [[(TemperatureFob *) obj1 idString] compare:[(TemperatureFob *) obj2 idString]];
//    }];
    self.foundFobs = [self.foundFobs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(TemperatureFob *) obj1 idString] compare:[(TemperatureFob *) obj2 idString]];
    }];
    
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.showNewFobSection)
        return 2;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return @"附近新的温度计";
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == STORED_FOBS_SECTION)
        return _fobArray.count;
    if (section == FOUND_FOBS_SECTION)
        return self.foundFobs.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TemperatureFob *fob;
    
    if (indexPath.section == STORED_FOBS_SECTION)
    {
        _storeFobCell = [tableView dequeueReusableCellWithIdentifier:@"TemperatureCell" forIndexPath:indexPath];
        fob = [_fobArray objectAtIndex:indexPath.row];
        _storeFobCell.delegate = self;
        [_storeFobCell setFob:fob];
        return _storeFobCell;
    }
    else
    {
        _newFobCell = [tableView dequeueReusableCellWithIdentifier:@"NewFobCell" forIndexPath:indexPath];
        fob = [self.foundFobs objectAtIndex:indexPath.row];
        [_newFobCell setFob:fob];
        return _newFobCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != FOUND_FOBS_SECTION)
        return;
    
    TemperatureFob *selectedFob = [self.foundFobs objectAtIndex:indexPath.row];
    selectedFob.isSaved = YES;
    selectedFob.delegate = self;
    
    if (![USER_DEFAULT objectForKey:KEY_SELECED_FOB]) {
        [USER_DEFAULT setObject:selectedFob.uuid forKey:KEY_SELECED_FOB];
        [USER_DEFAULT synchronize];
    }
    
    TemperatureFob* fob = [_detailInfo foundFobWithUUid:selectedFob.uuid];
    if (fob == nil) {
        [_detailInfo addFob:selectedFob];
    }
    [_fobArray addObject:selectedFob];
    [self cancelButtonPressed];
}

- (void) addButtonPressed
{
    [[ConnectionManager sharedInstance] setAcceptNewFobs:YES];
    self.showNewFobSection = YES;
    [self reloadData];
    
    [self.addActivityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = self.stopButton;
}

- (void) cancelButtonPressed
{
    [[ConnectionManager sharedInstance] setAcceptNewFobs:NO];
    self.showNewFobSection = NO;
    [_detailInfo deleteFoundFobs];
    [self reloadData];
    
    [self.addActivityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = self.addButton;
}
#pragma mark - TemperatureFobCellDelegate

-(void)selectedFobButtonTouched:(TemperatureFob *)fob
{
    if (![fob.uuid isEqualToString:[USER_DEFAULT objectForKey:KEY_SELECED_FOB]]) {
        _fob = fob;
        _alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您是否要设置此温度计为当前监测体温计？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [_alertView show];
    }
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [USER_DEFAULT removeObjectForKey:KEY_SELECED_FOB];
        [USER_DEFAULT setObject:_fob.uuid forKey:KEY_SELECED_FOB];
        [USER_DEFAULT synchronize];
        [_tableView reloadData];
    }
}
#pragma mark -ConnectionManagerDelegate
- (void) didDiscoverFob:(TemperatureFob *)fob
{
    fob.delegate = self;
    [self reloadData];
}
- (void) didUpdateData:(TemperatureFob *) fob
{
    NSLog(@"fob: temperature:%f,batteryLevel:%f,signalStrength:%f",[fob.temperature floatValue],[fob.batteryLevel floatValue],[fob.signalStrength floatValue]);
}
-(void) recentUpdateData:(NSData*)rawData
{

}

- (void) updateTimerCallback
{
    [self reloadData];
}


- (IBAction)scanButtonTouch:(UIButton *)sender {
    [[ConnectionManager sharedInstance] setAcceptNewFobs:YES];
    self.showNewFobSection = YES;
    [self reloadData];
    
    [self.addActivityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = self.cancelButton;
}
@end
