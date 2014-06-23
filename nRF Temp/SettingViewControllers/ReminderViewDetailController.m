//
//  ReminderViewDetailController.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "ReminderViewDetailController.h"
#import "PublicDefine.h"
#import "AppDelegate.h"

@interface ReminderViewDetailController ()

@end

@implementation ReminderViewDetailController

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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    CGRect oldRect = _datePickerView.frame;
    [_datePickerView setFrame:CGRectMake(0, DEVICE_HEIGHT, oldRect.size.width, oldRect.size.height)];
    [_datePickerView setHidden:YES];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIBarButtonItem* _saveButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = _saveButton;
    
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
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
#pragma mark -
-(void)tap
{
    [_contentCell.textField resignFirstResponder];
    [self timePickerHide];
}
-(void)cancelButtonPressed
{
    if (_isAdd) {
        [EventReminderModel deleteEventReminder:_reminderModel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveButtonPressed
{
    NSManagedObjectContext *managedObjectContext = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    NSManagedObjectContext *context = _reminderModel.managedObjectContext;  
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotice];
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenter_EventReminderChanged object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [imageView setImage:[UIImage imageNamed:@"reminder_alarm.png"]];
    [view addSubview:imageView];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return NO;
    }
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 50;
    }
    return 62;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"eventContentIdentifier" forIndexPath:indexPath];
        _contentCell.delegate = self;
        _contentCell.textField.text = _reminderModel.eventContent;
        return _contentCell;
    }
    else if (indexPath.row == 1)
    {
        _timeCell = [tableView dequeueReusableCellWithIdentifier:@"eventTimeIdentifier" forIndexPath:indexPath];
        
        NSDate* date = [NSDate dateWithTimeInterval:8*60*60 sinceDate:_reminderModel.time];
        NSString* dateStr = [[date.description substringToIndex:16]substringFromIndex:11];
        
//        NSString* dateStr = [[[_reminderModel time].description substringToIndex:16]substringFromIndex:11];
        _timeCell.timeLabel.text = dateStr;
        
        return _timeCell;
    }else{
        _repeatCell = [tableView dequeueReusableCellWithIdentifier:@"eventRepeatIdentifier" forIndexPath:indexPath];
        _repeatCell.delegate = self;
        [_repeatCell.switchView setOn:[_reminderModel.repeat boolValue] animated:YES];
        return _repeatCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [_contentCell.textField becomeFirstResponder];
        [self timePickerHide];
    }else if(indexPath.row == 1)
    {
        [self timePickerShow];
        [_contentCell.textField resignFirstResponder];
    }
}
#pragma mark - eventRepeatViewCellDelegate
-(void)repeatRemindisOpen:(BOOL)on
{
    _reminderModel.repeat = [NSNumber numberWithBool:on];
    if (on) {
        _localNotice.repeatInterval = NSDayCalendarUnit;
    }else{
        _localNotice.repeatInterval = NSCalendarUnitYear;
    }
}
#pragma mark - eventContentViewCellDelegate
-(void)updateTextField:(NSString*)content
{
    _reminderModel.eventContent = content;
    _localNotice.alertBody = content;
}
- (IBAction)datePickerChanged:(UIDatePicker *)sender
{
    NSDate* date = [NSDate dateWithTimeInterval:8*60*60 sinceDate:[sender date]];
    NSString* dateStr = [[date.description substringToIndex:16]substringFromIndex:11];
    _timeCell.timeLabel.text = dateStr;
    _reminderModel.time = sender.date;
    _localNotice.fireDate = sender.date;
}
#pragma mark - timePick animate
-(void)timePickerShow
{
    [_datePickerView setHidden:NO];
    [UIView animateWithDuration:0.6 animations:^{
        CGRect oldRect = _datePickerView.frame;
        [_datePickerView setFrame:CGRectMake(0, DEVICE_HEIGHT - oldRect.size.height, oldRect.size.width, oldRect.size.height)];
    }];
}
-(void)timePickerHide
{
    [UIView animateWithDuration:0.6 animations:^{
        CGRect oldRect = _datePickerView.frame;
        [_datePickerView setFrame:CGRectMake(0, DEVICE_HEIGHT, oldRect.size.width, oldRect.size.height)];
    } completion:^(BOOL finish){
        [_datePickerView setHidden:YES];
    }];
}

@end
