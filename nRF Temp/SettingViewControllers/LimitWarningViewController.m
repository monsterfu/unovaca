//
//  LimitWarningViewController.m
//  nRF Temp
//
//  Created by Monster on 14-4-10.
//
//

#import "LimitWarningViewController.h"

@interface LimitWarningViewController ()

@end

@implementation LimitWarningViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    _mostInt = [USER_DEFAULT integerForKey:KEY_MOST_STR];
    
    [_pickerView selectRow:_mostInt inComponent:0 animated:YES];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonPressed)];
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

-(void)saveButtonPressed
{
    [USER_DEFAULT removeObjectForKey:KEY_MOST_STR];
    [USER_DEFAULT removeObjectForKey:KEY_LOWEST_STR];
    [USER_DEFAULT setInteger:_mostInt forKey:KEY_MOST_STR];
    [USER_DEFAULT synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _mostCell = [tableView dequeueReusableCellWithIdentifier:@"mostCell" forIndexPath:indexPath];
    _mostCell.detailTextLabel.text = [NSString stringWithFormat:@"%d°C",[USER_DEFAULT integerForKey:KEY_MOST_STR]+37];
    return _mostCell;
}
#pragma mark - pickerView delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return DEVICE_WIDTH/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d°C",row+37];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _mostCell.detailTextLabel.text = [NSString stringWithFormat:@"%d°C",row+37];
    _mostInt = row;
}
@end
