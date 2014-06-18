//
//  RecordViewController.m
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

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
    
    _recordsOfMonthArray = [NSMutableArray array];
    [_datePicker setFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 216)];
    UIView* viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 20)];
    viewBg.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:viewBg];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUInteger year = [USER_DEFAULT integerForKey:KEY_SELECTED_YEAR];
    NSUInteger month = [USER_DEFAULT integerForKey:KEY_SELECTED_MONTH];
    
    NSDate* todayDate = [NSDate date];
    
    [_selectDateButton setTitle:[NSString stringWithFormat:@"%d年%d月",[todayDate year],[todayDate month]-1] forState:UIControlStateNormal];
    
    [_selectDateButton setTitle:[NSString stringWithFormat:@"%d年%d月",[todayDate year],[todayDate month]-1] forState:UIControlStateSelected];
    
    if (year&&month) {
        todayDate = [NSDate dateWithYear:year Month:month];
    }
    
    
    
    [self selectDateRecord:todayDate];
}

-(void)selectDateRecord:(NSDate*)date
{
    [_recordsOfMonthArray removeAllObjects];
    NSMutableArray* allDay = [NSDate currentMonthAllDay:date];
    for (NSDate* day in allDay) {
        NSArray* recordDay = [_fob lastReadingsDay:day];
        if ([recordDay count]) {
            [_recordsOfMonthArray addObject:[_fob lastReadingsDay:day]];
        }
    }
    [_tableView reloadData];
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

- (IBAction)newestDataButtonTouch:(UIButton *)sender {
    [self selectDateRecord:[NSDate date]];
}

- (IBAction)selectDateButtonTouched:(UIButton *)sender {
}


#pragma mark -tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recordsOfMonthArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    recordCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"recordCell"]];
    NSArray* recordArray = [_recordsOfMonthArray objectAtIndex:indexPath.row];
    [cell setRecordReadingArrayWithArray:recordArray];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelected!");
}
#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"curdayList"])
    {
        FobViewController* curfobListController = (FobViewController*)segue.destinationViewController;
        recordCell* cell = sender;
        curfobListController.readings = cell.recordReadingArray;
        curfobListController.person = _person;
    }
}
@end
