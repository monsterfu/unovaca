//
//  DeviceDetailViewController.m
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import "DeviceDetailViewController.h"

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
        _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"正在检测，请等待%d秒…",scanInt];
    }else{
        if (_fob.active) {
            _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"在线"];
        }else{
            _scanTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"离线"];
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
        _textField.enabled = NO;
        _textField.text = [_fob idString];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.borderStyle = UITextBorderStyleBezel;
        [cell addSubview:_textField];
    }else if(indexPath.row == 1)
    {
         _scanTableViewCell = cell;
    }
    else if(indexPath.row == 2)
    {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[_fob currentBatteryImage]];
        [imgView setFrame:CGRectMake(270, 12, 30, 12)];
        [cell addSubview:imgView];
    }else if(indexPath.row == 3)
    {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[_fob currentSignalStrengthImage]];
        [imgView setFrame:CGRectMake(270, 12, 24, 18)];
        [cell addSubview:imgView];
    }
    
    return cell;
}



- (IBAction)deleteButtonTouch:(UIButton *)sender {
    UIAlertView* question = [[UIAlertView alloc] initWithTitle:@"删除温度计"
                                                       message:[NSString stringWithFormat:@"你确定要删除温度计%@ ?", [self.fob location]]
                                                      delegate:self
                                             cancelButtonTitle:@"不删除"
                                             otherButtonTitles:@"删除", nil];
    [question show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [_person deleteFob:self.fob];
        
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
@end
