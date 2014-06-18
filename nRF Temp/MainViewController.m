//
//  MainViewController.m
//  nRF Temp
//
//  Created by Monster on 14-3-31.
//
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()
//@property NSArray *storedFobs;
//@property NSArray *foundFobs;
@property NSTimer *updateTimer;
@end

#define STORED_FOBS_SECTION 0
#define FOUND_FOBS_SECTION 1

@implementation MainViewController
@synthesize fob = _fob;

- (void) setFob:(TemperatureFob *)fob
{
    if (fob != _fob)
    {
        _fob = fob;
        _fob.delegate = self;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"智能蓝牙温度计";
    
    NSLog(@"self.navigationController.navigationBar.height:%f",self.navigationController.navigationBar.frame.size.height);
    if (![self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        self.navigationController.navigationBar.tintColor = _colorBg.backgroundColor;
        self.navigationController.navigationBar.translucent = NO;
    }else{
        self.navigationController.navigationBar.barTintColor = _colorBg.backgroundColor;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10.0, 0, 10.0)];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = delegate.managedObjectContext;
    
    [self showTemperatureImageWithValue:0.0f];
    
    [_textLabel setHidden:YES];
    
    CGFloat lowAngel = 45.0f/2.0f;
    lowAngel = lowAngel + (35 - 35)*45;
    
    NSLog(@"lowAngel:::%f",lowAngel);
    _lowPanelView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _lowPanelView.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
    [_lowPanelView setHidden:YES];
    
    _lowPanel2View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    _lowPanel2View.userInteractionEnabled = NO;
    _lowPanel2View.backgroundColor = [UIColor clearColor];
    UIImageView* testImageView = [[UIImageView alloc]initWithFrame:CGRectMake(138, 235, 42, 42)];
    [testImageView setImage:[UIImage imageNamed:@"plot@2x.png"]];
    [_lowPanel2View addSubview:testImageView];
    [self.view addSubview:_lowPanel2View];
    
    _lowPanel2View.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(lowAngel));
}
- (void)viewWillAppear:(BOOL)animated
{
    [[ConnectionManager sharedInstance] startScanForFobs];
    [[ConnectionManager sharedInstance] setDelegate:self];
    [[ConnectionManager sharedInstance] setAcceptNewFobs:YES];

    
    [self reloadData];

    
    //取默认的最高温度配置
    NSInteger tempLimit = [USER_DEFAULT integerForKey:KEY_MOST_STR];
    if (tempLimit == 0) {
        [USER_DEFAULT setInteger:42 - 37 forKey:KEY_MOST_STR];
        [USER_DEFAULT synchronize];
    }
    
    
    //取默认的用户名
    _detailInfo = [PersonDetailInfo PersonWithName:[USER_DEFAULT stringForKey:KEY_USERNAME]];
    
    
    if ([USER_DEFAULT stringForKey:KEY_FOBUUID]) {
        _fob = [_detailInfo foundFobWithUUid:[USER_DEFAULT stringForKey:KEY_FOBUUID] isSave:YES];
    }else{
        NSArray* arry;
        arry = [_detailInfo allStoredFobs];
        if ([arry count]) {
            _fob = [arry objectAtIndex:0];
        }
    }
    
    if (_fob) {
        _fob.delegate = self;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData
{
    [self.tableView reloadData];
    

}

-(void)showTemperatureImageWithValue:(CGFloat)value
{
    NSUInteger temValue = value*10;
    
    [_temp1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",temValue/100]]];
    [_temp2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",(temValue/10)%10]]];
    [_temp3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",temValue%10]]];

}

-(void)panelRotation:(CGFloat)value
{
    [UIView animateWithDuration:0.5f animations:^(void){
        CGFloat lowAngel = 45.0f/2.0f;
//        CGFloat highAngel =-1*lowAngel;
    if (value < 35) {
        _lowPanel2View.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(lowAngel));
//        _highPanelView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(highAngel));
    }else if(value > 42){
        _lowPanel2View.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(lowAngel));
//        _highPanelView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(highAngel));
    }else{
        lowAngel = lowAngel + (value - 35)*45;
        _lowPanel2View.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(lowAngel));
//        _highPanelView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(highAngel));
    }
    } completion:^(BOOL finish){
        NSLog(@"_lowPanelView.frame:%f,%f,%f,%f",_lowPanelView.frame.origin.x,_lowPanelView.frame.origin.y,_lowPanelView.frame.size.width,_lowPanelView.frame.size.height);
    }];
}
//- (void) updateTimerCallback
//{
//    [self reloadData];
//}
//
#pragma mark - ble delegate
- (void) isBluetoothEnabled:(bool)enabled
{
    NSLog(@"Is Bluetooth enabled: %d", enabled);
    if (enabled)
    {
        [[ConnectionManager sharedInstance] startScanForFobs];
    }else{
        _textLabel.text = @"未打开蓝牙";
    }
}
- (void) didDiscoverFob:(TemperatureFob *)fob
{
    _haveDevice = YES;
    fob.delegate = self;
    [self reloadData];
}
#pragma mark -table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//- (void)configurePersonCell:(PersonInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    if ([_personInfoArray count] > 0) {
//        NSInteger num = [USER_DEFAULT integerForKey:KEY_PERSON_SELECTED];
//        if (num > [_personInfoArray count]) {
//            num = 0;
//        }
//        _detailInfo = [_personInfoArray objectAtIndex:num];
//        cell.detailInfo = _detailInfo;
//    }
//	
//}

//- (void)configureHistoryCell:(LastHistoryCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    
//	TemperatureFob *detailInfo = (TemperatureFob *)[_storedFobs objectAtIndex:indexPath.row];
//    cell.temperatureFob = detailInfo;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInfoCell *personCell;
    LastHistoryCell* historyCell;
    
    if (indexPath.row == 0)
    {
        personCell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoCell" forIndexPath:indexPath];
        personCell.detailInfo = _detailInfo;
        return personCell;
    }
    else
    {
        historyCell = [tableView dequeueReusableCellWithIdentifier:@"lastNoticeCell" forIndexPath:indexPath];
        if (_fob) {
            historyCell.temperatureFob = _fob;
            [historyCell.tempLabel setHidden:NO];
            [historyCell.timeLabel setHidden:NO];
            [historyCell.noHistoryRemindLabel setHidden:YES];
        }else{
            [historyCell.tempLabel setHidden:YES];
            [historyCell.timeLabel setHidden:YES];
            [historyCell.noHistoryRemindLabel setHidden:NO];
        }
        return historyCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -segete
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"personDetail"])
    {
        PersonViewController * curPersonController = (PersonViewController *)segue.destinationViewController;
        curPersonController.detailInfo = _detailInfo;
    }else if ([segue.identifier isEqualToString:@"deviceLIst"])
    {
        ListViewController * curListViewController = (ListViewController *)segue.destinationViewController;
        curListViewController.detailInfo = _detailInfo;
    }else if ([segue.identifier isEqualToString:@"recordIdentifier"])
    {
        RecordViewController* curRecordViewController = (RecordViewController*)segue.destinationViewController;
        
        [USER_DEFAULT removeObjectForKey:KEY_SELECTED_YEAR];
        [USER_DEFAULT removeObjectForKey:KEY_SELECTED_MONTH];
        
        curRecordViewController.fob = _fob;
        curRecordViewController.person = _detailInfo;
    }
}
#pragma mark temperaturefob delegate

- (void) didUpdateData:(TemperatureFob *) fob
{
    _haveDevice = YES;
    [self reloadData];
}
-(void) recentUpdateData:(NSData*)rawData
{
//    TemperatureReading *lastReading = [[_storedFobs objectAtIndex:0] lastReading];
    //    _label.text = [NSString stringWithFormat:@"%.01f ℃", lastReading.value.floatValue];
    
    uint32_t raw;
    [rawData getBytes:&raw length:4];
    
    int8_t exponent = (raw & 0xFF000000) >> 24;
    int32_t mantissa = (raw & 0x00FFFFFF);
    if (mantissa & 0x00800000)
    {
        mantissa |= (0xFF000000);
    }
    
    CGFloat value = mantissa * pow(10.0, exponent);
    
    if (YES == [USER_DEFAULT boolForKey:KEY_WARNING_OPEN])
    {
        NSInteger savedTemp = [USER_DEFAULT integerForKey:KEY_MOST_STR] +37;
        NSLog(@"saveTemp ================================================>%d",savedTemp);
        if (value > savedTemp)
        {
            [[soundVibrateManager sharedInstance]playAlertSound];
            [[soundVibrateManager sharedInstance]vibrate];
        }
    }
    
    [self showTemperatureImageWithValue:value];
    [self panelRotation:value];
    
    if (value< 35.0f) {
        _textLabel.text = @"请正确使用体温计";
        _status.text = @"异常";
    }
    else if ((value < 39.0f)&&(value >= 38.0f)) {
        _textLabel.text = @"低烧";
        _status.text = @"低烧";
    }
    else if(value >= 39.0f){
        _textLabel.text = @"高烧";
        _status.text = @"高烧";
    }
    else{
        _textLabel.text = @"体温正常";
        _status.text = @"正常";
    }
    
    [_textLabel setHidden:NO];
}
@end
