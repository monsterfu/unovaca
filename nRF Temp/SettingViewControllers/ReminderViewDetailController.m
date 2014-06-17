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
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIBarButtonItem* _saveButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = _saveButton;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenter_EventReminderChanged object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableViewDelegate
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
    if (indexPath.row == 2) {
        return 62;
    }
    return 50;
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
        return _contentCell;
    }
    else if (indexPath.row == 1)
    {
        _timeCell = [tableView dequeueReusableCellWithIdentifier:@"eventTimeIdentifier" forIndexPath:indexPath];
        return _timeCell;
    }else{
        _repeatCell = [tableView dequeueReusableCellWithIdentifier:@"eventRepeatIdentifier" forIndexPath:indexPath];
        _repeatCell.delegate = self;
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
}
#pragma mark - eventContentViewCellDelegate
-(void)updateTextField:(NSString*)content
{
    _reminderModel.eventContent = content;
}
- (IBAction)datePickerChanged:(UIDatePicker *)sender
{    
    NSString* dateStr = [[[sender date].description substringToIndex:16]substringFromIndex:11];
    _timeCell.timeLabel.text = dateStr;
    _reminderModel.time = sender.date;
}
#pragma mark - timePick animate
-(void)timePickerShow
{
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
    }];
}

@end
