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
//    NSUInteger year = [yearStr integerValue];
    
    NSString* monthStr = [dateStr substringToIndex:7];
    monthStr = [monthStr substringFromIndex:5];
    NSUInteger month = [monthStr integerValue];
    
    yearIndex = [curDate year];
    monthIndex = [curDate month] -1;
    
    [_picker selectRow:10 inComponent:0 animated:YES];
    [_picker selectRow:month - 1 inComponent:1 animated:YES];
    
    _yearSr = [yearStr stringByAppendingString:@"年"];
    _monthSr = [[NSString stringWithFormat:@"%d",month]stringByAppendingString:@"月"];
    
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
    return @"选择记录日期";
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
        _yearSr = [NSString stringWithFormat:@"%d年",yearEx];
    }else{
        NSArray* monthArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
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
        
        return [NSString stringWithFormat:@"%d年",yearEx];
    }else{
        NSArray* monthArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        return [monthArray objectAtIndex:row];
    }
}
@end
