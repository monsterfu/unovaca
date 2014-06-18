//
//  SettingViewController.m
//  nRF Temp
//
//  Created by Monster on 14-4-4.
//
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _timeGapArray = @[@"5秒",@"10秒",@"5分钟",@"10分钟",@"15分钟",@"30分钟",@"1小时"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }else{
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row+1];
    }else{
        CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row+3];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.detailTextLabel.text = [_timeGapArray objectAtIndex:[USER_DEFAULT integerForKey:KEY_GAPTIMER_STR]];
    }else if(indexPath.section == 0 && indexPath.row == 0)
    {
        [label removeFromSuperview];
        [switchView removeFromSuperview];
        label = [[UILabel alloc]initWithFrame:CGRectMake(190, 6, 60, 30)];
        label.text = [NSString stringWithFormat:@"%d°C",[USER_DEFAULT integerForKey:KEY_MOST_STR]+37];
        //.text = [NSString stringWithFormat:@"%d°C",[USER_DEFAULT integerForKey:KEY_MOST_STR]+25];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        [cell addSubview:label];
        switchView = [[UISwitch alloc]initWithFrame:CGRectMake(240, 6, 0, 0)];
        [switchView addTarget:self action:@selector(switchViewAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchView];
        switchView.on = [USER_DEFAULT boolForKey:KEY_WARNING_OPEN];
    }
    // Configure the cell...
    
    return cell;
}

-(void)switchViewAction:(UISwitch*)sender
{
    [USER_DEFAULT removeObjectForKey:KEY_WARNING_OPEN];
    [USER_DEFAULT setBool:sender.on forKey:KEY_WARNING_OPEN];
    [USER_DEFAULT synchronize];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
