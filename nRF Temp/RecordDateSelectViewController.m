//
//  RecordDateSelectViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-16.
//
//

#import "RecordDateSelectViewController.h"

@interface RecordDateSelectViewController ()

@end

#define YEAR_TOTAL_NUM (10)

@implementation RecordDateSelectViewController

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
    
    _picker.delegate = self;
    _picker.dataSource = self;
    
    _picker.showsSelectionIndicator = YES;
    
    
    NSDate* curDate = [NSDate date];
    NSString* dateStr = [curDate description];
    NSString* yearStr = [dateStr substringToIndex:4];
    
    yearIndex = [curDate year];
    monthIndex = [curDate month];
    
    [_picker selectRow:10 inComponent:0 animated:YES];
    [_picker selectRow:monthIndex-1 inComponent:1 animated:YES];
    
    _yearSr = [yearStr stringByAppendingString:NSLocalizedString(@"年",nil)];
    
    NSArray* monthArray = @[NSLocalizedString(@"1月",nil), NSLocalizedString(@"2月",nil),NSLocalizedString(@"3月",nil),NSLocalizedString(@"4月",nil),NSLocalizedString(@"5月",nil),NSLocalizedString(@"6月",nil),NSLocalizedString(@"7月",nil),NSLocalizedString(@"8月",nil), NSLocalizedString(@"9月",nil),NSLocalizedString(@"10月",nil),NSLocalizedString(@"11月",nil), NSLocalizedString(@"12月",nil)];
    
    _monthSr = [monthArray objectAtIndex:monthIndex-1];
    
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

- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    [USER_DEFAULT removeObjectForKey:KEY_SELECTED_YEAR];
    [USER_DEFAULT removeObjectForKey:KEY_SELECTED_MONTH];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    
    [USER_DEFAULT removeObjectForKey:KEY_SELECTED_YEAR];
    [USER_DEFAULT removeObjectForKey:KEY_SELECTED_MONTH];
    
    [USER_DEFAULT setInteger:yearIndex forKey:KEY_SELECTED_YEAR];
    [USER_DEFAULT setInteger:monthIndex forKey:KEY_SELECTED_MONTH];
    
    [USER_DEFAULT synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        
    }];
}

#pragma mark - tableView delegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"选择记录日期",nil);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cellrecord1"]];
    _cell.textLabel.text = [_yearSr stringByAppendingString:_monthSr];
    return _cell;
}
#pragma mark - picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSDate* curDate = [NSDate date];
        NSString* dateStr = [curDate description];
        NSString* yearStr = [dateStr substringToIndex:4];
        NSUInteger year = [yearStr integerValue];
        NSUInteger yearEx = year - 10 + row;
        yearIndex = yearEx;
        _yearSr = [NSString stringWithFormat:@"%d%@",yearEx,NSLocalizedString(@"年",nil)];
    }else{
        NSArray* monthArray = @[NSLocalizedString(@"1月",nil), NSLocalizedString(@"2月",nil),NSLocalizedString(@"3月",nil),NSLocalizedString(@"4月",nil),NSLocalizedString(@"5月",nil),NSLocalizedString(@"6月",nil),NSLocalizedString(@"7月",nil),NSLocalizedString(@"8月",nil), NSLocalizedString(@"9月",nil),NSLocalizedString(@"10月",nil),NSLocalizedString(@"11月",nil), NSLocalizedString(@"12月",nil)];
        
        _monthSr = [monthArray objectAtIndex:row];
        monthIndex = row+1;
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return YEAR_TOTAL_NUM + 1;
    }else{
        return 12;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 120;
    }else{
        return 70;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDate* curDate = [NSDate date];
        NSString* dateStr = [curDate description];
        NSString* yearStr = [dateStr substringToIndex:4];
        NSUInteger year = [yearStr integerValue];
        NSUInteger yearEx = year - 10 + row;
        
        return [NSString stringWithFormat:@"%d%@",yearEx,NSLocalizedString(@"年",nil)];;
    }else{
        NSArray* monthArray = @[NSLocalizedString(@"1月",nil), NSLocalizedString(@"2月",nil),NSLocalizedString(@"3月",nil),NSLocalizedString(@"4月",nil),NSLocalizedString(@"5月",nil),NSLocalizedString(@"6月",nil),NSLocalizedString(@"7月",nil),NSLocalizedString(@"8月",nil), NSLocalizedString(@"9月",nil),NSLocalizedString(@"10月",nil),NSLocalizedString(@"11月",nil), NSLocalizedString(@"12月",nil)];
        return [monthArray objectAtIndex:row];
    }
}
@end
