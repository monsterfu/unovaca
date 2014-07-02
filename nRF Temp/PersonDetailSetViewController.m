//
//  PersonDetailSetViewController.m
//  nRF Temp
//
//  Created by Monster on 14-4-4.
//
//

#import "PersonDetailSetViewController.h"

@interface PersonDetailSetViewController ()

@end

@implementation PersonDetailSetViewController

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
    
    _saveButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = _saveButton;
    
    
    _cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backhl.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
//    [_cancelButton setImageInsets:UIEdgeInsetsMake(6, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    _sexArray = [NSArray arrayWithObjects:NSLocalizedString(@"男",nil),NSLocalizedString(@"女",nil), nil];
    _bloodArray = @[@"A",@"B",@"AB",@"O"];
    _titleArray = @[NSLocalizedString(@"名字",nil),NSLocalizedString(@"生日",nil),NSLocalizedString(@"性别",nil),NSLocalizedString(@"身高",nil),NSLocalizedString(@"体重",nil),NSLocalizedString(@"血型",nil)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _pickerView.center = _tableView.center;
    _datePicker.center = _tableView.center;
    if (_detailInfo.birthday) {
        _datePicker.date = _detailInfo.birthday;
    }
    
    _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:[[USER_DEFAULT objectForKey : @"AppleLanguages"]objectAtIndex:0]];
    _birthDate = _datePicker.date;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_datePicker setMaximumDate:[NSDate date]];
    _selectItem = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_PERSONDETAIL_SELECT_STR];
    switch (_selectItem) {
        case PersonInfoNickName:
        {
            [_pickerView setHidden:YES];
            [_datePicker setHidden:YES];
            break;
        }
        case PersonInfoBirthday:
        {
            [_pickerView setHidden:YES];
            [_tableView setHidden:YES];
            break;
        }
        case PersonInfoBlood:
        {
            [_pickerView setHidden:YES];
            [_datePicker setHidden:YES];
            break;
        }
        case PersonInfoHeight:
        {
            [_datePicker setHidden:YES];
            [_tableView setHidden:YES];
            if (_detailInfo.weight) {
                if ([_detailInfo.weight integerValue]) {
                    [_pickerView selectRow:[_detailInfo.weight integerValue] inComponent:0 animated:YES];
                }else{
                    _selectTableCellIndex = 30;
                    [_pickerView selectRow:30 inComponent:0 animated:YES];
                }
            }else{
                _selectTableCellIndex = 50;
                [_pickerView selectRow:50 inComponent:0 animated:YES];
            }
            
            break;
        }
       case PersonInfoHigh:
        {
            [_datePicker setHidden:YES];
            [_tableView setHidden:YES];
            if (_detailInfo.high)
                if ([_detailInfo.high integerValue]) {
                    [_pickerView selectRow:[_detailInfo.high integerValue] inComponent:0 animated:YES];
                }else{
                    [_pickerView selectRow:50 inComponent:0 animated:YES];
                    _selectTableCellIndex = 50;
                    }
                else{
                [_pickerView selectRow:50 inComponent:0 animated:YES];
                    _selectTableCellIndex = 50;
                }
            
            break;
        }
        case PersonInfoSex:
        {
            [_pickerView setHidden:YES];
            [_datePicker setHidden:YES];
            break;
        }
        default:
            break;
    }
    self.title = [_titleArray objectAtIndex:_selectItem-1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButtonPressed
{
    switch (_selectItem) {
        case PersonInfoNickName:
        {
            [USER_DEFAULT setObject:_textfieldLabel.text forKey: KEY_NICKNAME_STR];
            _detailInfo.name = _textfieldLabel.text;
            break;
        }
        case PersonInfoBirthday:
        {
            [USER_DEFAULT setObject:_birthDate forKey: KEY_BIRTH_STR];
            _detailInfo.birthday = _birthDate;
            break;
        }
        case PersonInfoBlood:
        {
            [USER_DEFAULT setInteger:_selectTableCellIndex forKey:KEY_BLOOD_STR];
            _detailInfo.blood = [NSNumber numberWithInteger:_selectTableCellIndex];
            break;
        }
        case PersonInfoHeight:
        {
            [USER_DEFAULT setInteger:_selectTableCellIndex forKey:KEY_HEIGHT_STR];
            _detailInfo.weight = [NSNumber numberWithInteger:_selectTableCellIndex];
            break;
        }
        case PersonInfoHigh:
        {
            [USER_DEFAULT setInteger:_selectTableCellIndex forKey:KEY_HIGH_STR];
            _detailInfo.high = [NSNumber numberWithInteger:_selectTableCellIndex];
            break;
        }
        case PersonInfoSex:
        {
            [USER_DEFAULT setInteger:_selectTableCellIndex forKey:KEY_SEX_STR];
            if (_selectTableCellIndex) {
                _detailInfo.sex = [NSNumber numberWithBool:NO];
            }else
            {
                _detailInfo.sex = [NSNumber numberWithBool:YES];
            }
            break;
        }
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectItem == PersonInfoNickName) {
        return 35;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger num = 0;
    switch (_selectItem) {
        case PersonInfoNickName:
        {
            num = 1;
            break;
        }
        case PersonInfoBirthday:
        case PersonInfoHigh:
        case PersonInfoHeight:
        {
            num = 0;
            break;
        }
        case PersonInfoSex:
        {
            num = 2;
            break;
        }
        case PersonInfoBlood:
        {
            num = 4;
            break;
        }
        default:
            break;
    }
    return num;
}
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellAccessoryCheckmark;
//}
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailSetCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (_selectItem) {
        case PersonInfoNickName:
        {
            _textfieldLabel = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, cell.frame.size.width -20, cell.frame.size.height-10)];
            _textfieldLabel.delegate = self;
            _textfieldLabel.center = cell.center;
            _textfieldLabel.allowsEditingTextAttributes = YES;
            _textfieldLabel.font = [UIFont systemFontOfSize:18];
            _textfieldLabel.placeholder = NSLocalizedString(@"请输入昵称",nil);
            _textfieldLabel.clearButtonMode = UITextFieldViewModeAlways;
            [_textfieldLabel becomeFirstResponder];
            [cell addSubview:_textfieldLabel];
            _textfieldLabel.text = _detailInfo.name;
            break;
        }
        case PersonInfoBirthday:
        case PersonInfoHigh:
        case PersonInfoHeight:
            break;
        case PersonInfoSex:
        {
            cell.textLabel.text = [_sexArray objectAtIndex:indexPath.row];
            if (indexPath.row == 0&&[_detailInfo.sex boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                _selectTableCellIndex = 0;
            }else if (indexPath.row == 1&&![_detailInfo.sex boolValue]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                _selectTableCellIndex = 1;
            }
        }
            break;
        case PersonInfoBlood:
        {
            cell.textLabel.text = [_bloodArray objectAtIndex:indexPath.row];
            if (indexPath.row == [_detailInfo.blood integerValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                _selectTableCellIndex = indexPath.row;
            }
        }
        default:
            break;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index;
    if (_detailInfo != nil) {
        switch (_selectItem) {
            case PersonInfoBlood:
            {
                index = _selectTableCellIndex;
                NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
                checkedCell.accessoryType = UITableViewCellAccessoryNone;
                
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                // Deselect the row.
//                _detailInfo.blood = [NSNumber numberWithInteger:indexPath.row];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
                break;
            case PersonInfoSex:
            {
                if ([_detailInfo.sex boolValue]) {
                    index = 1;
                }else{
                    index = 0;
                }
                index = _selectTableCellIndex;
                NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
                checkedCell.accessoryType = UITableViewCellAccessoryNone;
                
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                // Deselect the row.
//                _detailInfo.sex = [NSNumber numberWithBool:indexPath.row];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
                break;
            default:
                index = 1;
                break;
        }
		
		
    }
    _selectTableCellIndex = indexPath.row;
}
#pragma mark - pickerView delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSUInteger num = 0;
    switch (_selectItem) {
        case PersonInfoNickName:
        case PersonInfoBirthday:
        case PersonInfoHigh:
        case PersonInfoHeight:
        {
            num = 1;
            break;
        }
        case PersonInfoSex:
        case PersonInfoBlood:
            break;
        default:
            break;
    }
    return num;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger num = 0;
    switch (_selectItem) {
        case PersonInfoNickName:
        case PersonInfoBirthday:
            break;
        case PersonInfoHigh:
        {
            num = 250;
            break;
        }
        case PersonInfoHeight:
        {
            num = 300;
            break;
        }
        case PersonInfoSex:
        case PersonInfoBlood:
            break;
        default:
            break;
    }
    return num;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return DEVICE_WIDTH;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = nil;
    switch (_selectItem) {
        case PersonInfoNickName:
        case PersonInfoBirthday:
            break;
        case PersonInfoHigh:
        {
            str = [NSString stringWithFormat:@"%dCM",row];
            break;
        }
        case PersonInfoHeight:
        {
            str = [NSString stringWithFormat:@"%dkg",row];
            break;
        }
        case PersonInfoSex:
        case PersonInfoBlood:
            break;
        default:
            break;
    }
    return str;
}
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectTableCellIndex = row;
}
#pragma mark - datepicker
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    /*添加你自己响应代码*/
    _birthDate = control.date;
}
#pragma mark - textfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField             // called when 'return' key pressed. return NO to ignore.
{
    NSString* name = textField.text;
    [USER_DEFAULT setObject:name forKey: KEY_NICKNAME_STR];
    [self saveButtonPressed];
    return YES;
}

@end
