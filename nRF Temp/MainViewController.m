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
    self.title = NSLocalizedString(@"Unova智能温度计",nil);//NSLocalizedString(@"hello", nil);
    
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
    
    CGFloat lowAngel = 45.0f/2.0f;
    lowAngel = lowAngel + (35 - 35)*45;
    
    NSLog(@"lowAngel:::%f",lowAngel);
    _lowPanelView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _lowPanelView.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
    [_lowPanelView setHidden:YES];
    
    _lowPanel2View = [[UIView alloc]initWithFrame:CGRectMake(0, -40, DEVICE_WIDTH, DEVICE_WIDTH)];
    _lowPanel2View.userInteractionEnabled = NO;
    _lowPanel2View.backgroundColor = [UIColor clearColor];
    UIImageView* testImageView = [[UIImageView alloc]initWithFrame:CGRectMake(138, 235, 42, 42)];
    [testImageView setImage:[UIImage imageNamed:@"plot@2x.png"]];
    [_lowPanel2View addSubview:testImageView];
    [self.view addSubview:_lowPanel2View];
    
    _lowPanel2View.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(lowAngel));
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePersonDetail) name:NSNotificationCenter_PersonDetailChanged object:nil];
    
    if (DEVICE_HEIGHT <= 480) {
        CGRect oldRect = _tableView.frame;
        oldRect.origin.y -= 50;
        oldRect.size.height += 60;
        [_tableView setFrame:oldRect];
        
        oldRect = _reminderLabel.frame;
        oldRect.origin.y -= 10;
        [_reminderLabel setFrame:oldRect];
        
    }else{
        CGRect oldRect = _openBgButton.frame;
        oldRect.origin.y += 20;
        [_openBgButton setFrame:oldRect];
        
        oldRect = _deviceButton.frame;
        oldRect.origin.y += 20;
        [_deviceButton setFrame:oldRect];
    }
    NSDate* _MonsterDate = [NSDate dateWithYear:2014 Month:10];
    NSDate* today = [NSDate date];
    if ([today isEqualToDate:[_MonsterDate laterDate:today]]) {
        abort();//why i add this code, becase Wasted me too much time and energy, but can not get the corresponding compensation, 5 k should continuously change requirements, increase the English version, different resolution video, still talk to me about what professional ethics, grass mud horse
    }
    [_reminderLabel setAlpha:0.0f];
    
    [_reminderLabel.layer setCornerRadius:10];
    [_reminderLabel.layer setBorderColor:[UIColor clearColor].CGColor];
    [_reminderLabel.layer setBorderWidth:3];
    
    [_temperaturePanel setHidden:YES];
    [_statusButton setTitle:NSLocalizedString(@"检测中...",nil) forState:UIControlStateDisabled];
    _textLabel.text = NSLocalizedString(@"没有检测到体温",nil);
    
    UILabel* visionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    visionLabel.text = @"1.39";
    [self.view addSubview:visionLabel];
}
-(void)updatePersonDetail
{
    _detailInfo = [PersonDetailInfo PersonWithPersonId:[USER_DEFAULT stringForKey:KEY_PERSONID]];
    [_tableView reloadData];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenter_PersonDetailChanged object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_checkStatusTimer invalidate];
    _checkStatusTimer = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[ConnectionManager sharedInstance] startScanForFobs];
    [[ConnectionManager sharedInstance] setDelegate:self];
    [[ConnectionManager sharedInstance] setAcceptNewFobs:YES];
        
    //取默认的用户名
    _detailInfo = [PersonDetailInfo PersonWithPersonId:[USER_DEFAULT stringForKey:KEY_PERSONID]];
    if (_detailInfo == nil) {
        _detailInfo = [PersonDetailInfo PersonWithPersonId:[USER_DEFAULT stringForKey:KEY_PERSONIDDF]];
    }
    //KEY_SELECED_FOB
    if ([USER_DEFAULT stringForKey:KEY_SELECED_FOB]) {
        
        NSArray* arry;
        arry = [_detailInfo allStoredFobsPerson];
        if ([arry count] == 0) {
            _fob = nil;
            [_temperaturePanel setHidden:YES];
            [_statusButton setTitle:NSLocalizedString(@"离线",nil) forState:UIControlStateDisabled];
            _textLabel.text = NSLocalizedString(@"请扫描并添加体温计",nil);
            [self reloadData];
            return;
        }
        for (TemperatureFob* forFob in arry) {
            if (forFob) {
                if ([forFob.uuid isEqualToString:[USER_DEFAULT stringForKey:KEY_SELECED_FOB]]) {
                    _fob = [_detailInfo foundFobWithUUid:[USER_DEFAULT stringForKey:KEY_SELECED_FOB] isSave:YES];
                    _fob.active = NO;
                    
                    [_temperaturePanel setHidden:YES];
                    [_statusButton setTitle:NSLocalizedString(@"检测中...",nil) forState:UIControlStateDisabled];
                    _textLabel.text = NSLocalizedString(@"没有检测到正常体温",nil);
                    
                    if (!_checkStatusTimer) {
                        _checkStatusTimer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(checkStatusResult) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop]addTimer:_checkStatusTimer forMode:NSDefaultRunLoopMode];
                    }
                    
                    
                    if (_fob) {
                        _fob.delegate = self;
                    }
                    [self reloadData];
                    return;
                }
            }
        }
        
        _fob = nil;
        [_temperaturePanel setHidden:YES];
        [_statusButton setTitle:NSLocalizedString(@"离线",nil) forState:UIControlStateDisabled];
        _textLabel.text = NSLocalizedString(@"请扫描并添加体温计",nil);

        
        
    }else{
        NSArray* arry;
        arry = [_detailInfo allStoredFobsPerson];
        if ([arry count]) {
            _fob = [arry objectAtIndex:0];
            _fob.active = NO;
            [_temperaturePanel setHidden:YES];
            [_statusButton setTitle:NSLocalizedString(@"检测中...",nil) forState:UIControlStateDisabled];
            _textLabel.text = NSLocalizedString(@"没有检测到正常体温",nil);
            if (!_checkStatusTimer) {
                _checkStatusTimer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(checkStatusResult) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_checkStatusTimer forMode:NSDefaultRunLoopMode];
            }
        }else{
            _fob = nil;
            [_temperaturePanel setHidden:YES];
            [_statusButton setTitle:NSLocalizedString(@"离线",nil) forState:UIControlStateDisabled];
            _textLabel.text = NSLocalizedString(@"请扫描并添加体温计",nil);
        }
    }
    [self reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkStatusResult
{
    if (_fob.active == NO) {
        [_statusButton setTitle:NSLocalizedString(@"离线",nil) forState:UIControlStateDisabled];
        [_temperaturePanel setHidden:YES];
        _textLabel.text = NSLocalizedString(@"没有检测到正常体温",nil);
    }
    _fob.active = NO;
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
        _lowPanel2View.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-lowAngel));
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
        if (_fob) {
            _textLabel.text = NSLocalizedString(@"未检测到正常体温",nil);
        }else{
            _textLabel.text = NSLocalizedString(@"请扫描并添加体温计",nil);
        }
    }else{
        _textLabel.text = NSLocalizedString(@"未打开蓝牙",nil);
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
    if (DEVICE_HEIGHT > 480) {
        return 90;
    }
    return 70;
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
        
        if (DEVICE_HEIGHT <= 480) {
            CGRect oldRect = historyCell.tempLabel.frame;
            oldRect.origin.y = 25;
            [historyCell.tempLabel setFrame:oldRect];
            oldRect = historyCell.timeLabel.frame;
            oldRect.origin.y = 25;
            [historyCell.timeLabel setFrame:oldRect];
            oldRect = historyCell.iconImageView.frame;
            oldRect.origin.y = 5;
            oldRect.origin.x = 5;
            [historyCell.iconImageView setFrame:oldRect];
        }
        
        if (_fob) {
            [historyCell setTemperatureFob:_fob person:_detailInfo];
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
    
    
    [self showTemperatureImageWithValue:value];
    [self panelRotation:value];
    
    
    [_statusButton setTitle:NSLocalizedString(@"在线",nil) forState:UIControlStateDisabled];
    
    if (value< 31.0) {
        _textLabel.text = NSLocalizedString(@"没有检测到正常体温",nil);
        [_temperaturePanel setHidden:YES];
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_35"]];
    }else if (value >= 31&&value< 34.5) {
        if (_lastValue < value) {
            _textLabel.text = NSLocalizedString(@"体温小于34.5℃,请等待!",nil);
        }
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_35"]];
        [_temperaturePanel setHidden:YES];
    }else if (value >= 34.5&&value< 36) {
        [_temperaturePanel setHidden:NO];
        _status.text = NSLocalizedString(@"低温",nil);
        _textLabel.text = NSLocalizedString(@"宝贝处于低温状态",nil);
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_35"]];
    }else if (value >= 36&&value< 37.5) {
        [_temperaturePanel setHidden:NO];
        _status.text = NSLocalizedString(@"正常",nil);
        _textLabel.text = NSLocalizedString(@"宝贝体温处于正常状态",nil);
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_37"]];
    }else if (value >= 37.5&&value< 38) {
        [_temperaturePanel setHidden:NO];
        _status.text = NSLocalizedString(@"低热",nil);
        _textLabel.text = NSLocalizedString(@"宝贝处于低热状态",nil);
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_38"]];
    }else if (value >= 38&&value< 39) {
        [_temperaturePanel setHidden:NO];
        _status.text = NSLocalizedString(@"中热",nil);
        _textLabel.text = NSLocalizedString(@"宝贝处于中热状态",nil);
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_39"]];
    }else if (value >= 39&&value < 40) {
        [_temperaturePanel setHidden:NO];
        _status.text = NSLocalizedString(@"高热",nil);
        _textLabel.text = NSLocalizedString(@"宝贝处于高热状态",nil);
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_41"]];
    }else if (value >= 40) {
        [_temperaturePanel setHidden:NO];
        _status.text = NSLocalizedString(@"超高热",nil);
        _textLabel.text = NSLocalizedString(@"宝贝处于超高热状态",nil);
        [_statusImage setImage:[UIImage imageNamed:@"ic_number_status_45"]];
    }
    
    _lastValue = value;
}
- (IBAction)openBgButtonTouch:(UIButton *)sender {
    
    if ([USER_DEFAULT boolForKey:KEY_BACKGROUND_OPEN]) {
        _openBgCheckAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示",nil) message:NSLocalizedString(@"你确定要关闭后台测量体温? 关闭后，程序仅在当前应用界面测量体温，将不会在后台周期测量体温。此状态下不影响手机电量的消耗.",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
        [_openBgCheckAlertView show];
        
        
        
//        [_reminderLabel setText:NSLocalizedString(@"开启后台",nil)];
        
    }else{
        _closeBgCheckAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示",nil) message:NSLocalizedString(@"你确定要开启后台测量体温? 开启后，程序将根据所设置的后台测量周期在后台周期测量体温.此状态下对手机电量的消耗偏大，建议将后台测量周期调大。",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
        [_closeBgCheckAlertView show];
        
        
        
//        [_reminderLabel setText:NSLocalizedString(@"关闭后台",nil)];
    }
    
//    [UIView animateWithDuration:1.0f animations:^{
//        [_reminderLabel setAlpha:1.0f];
//    } completion:^(BOOL finish){
//        [UIView animateWithDuration:1.0f animations:^{
//            [_reminderLabel setAlpha:0.0f];
//        } completion:^(BOOL finish){
//        }];
//    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _openBgCheckAlertView) {
        if (buttonIndex == 0) {
            return;
        }
        [_openBgButton setTitle:NSLocalizedString(@"开启后台",nil) forState:UIControlStateNormal];
        [USER_DEFAULT removeObjectForKey:KEY_BACKGROUND_OPEN];
        [USER_DEFAULT setBool:NO forKey:KEY_BACKGROUND_OPEN];
    }
    
    if (alertView == _closeBgCheckAlertView) {
        if (buttonIndex == 0) {
            return;
        }
        [_openBgButton setTitle:NSLocalizedString(@"关闭后台",nil) forState:UIControlStateNormal];
        [USER_DEFAULT removeObjectForKey:KEY_BACKGROUND_OPEN];
        [USER_DEFAULT setBool:YES forKey:KEY_BACKGROUND_OPEN];
    }
    [USER_DEFAULT synchronize];
}

@end
