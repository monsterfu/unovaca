//
//  fourDetalViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import "fourDetalViewController.h"


@interface fourDetalViewController ()

@end

@implementation fourDetalViewController

#define  str_yfrq   @"[易发人群]:"
#define  str_cjzz   @"[常见症状]:"
#define  str_js     @"[介绍]:"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dic:(NSDictionary*)dic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contentDic = dic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setContent:_contentDic];
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    UIView* view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:view];
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


-(void)setContent:(NSDictionary *)contentDic
{
    self.title = [contentDic objectForKey:@"name"];
    _contentArray = [NSMutableArray array];
    [_contentArray addObject:[NSString stringWithFormat:@"%@%@\n%@%@\n%@%@",str_yfrq,[contentDic objectForKey:@"incidentCrowd"],str_cjzz,[contentDic objectForKey:@"commonSymptom"],str_js,[contentDic objectForKey:@"desc"]]];
    [_contentArray addObject:[contentDic objectForKey:@"treatment"]];
    [_contentArray addObject:[contentDic objectForKey:@"incidentSeason"]];
    [_contentArray addObject:[contentDic objectForKey:@"precautionarMeasures"]];
    [_contentArray addObject:[contentDic objectForKey:@"prognosisMeasures"]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_contentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = [_contentArray objectAtIndex:indexPath.section];
    if (text) {
        CGSize size =  [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT*2) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+60;
    }
    return 30;
}


+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diseaseCell"];//[tableView dequeueReusableCellWithIdentifier:@"diseaseCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    // Configure the cell...
    cell.textLabel.text = [_contentArray objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor grayColor];
    [cell.textLabel setNumberOfLines:80];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    if (indexPath.section == 0) {
        cell.backgroundColor = [fourDetalViewController colorFromHexRGB:@"8CBA44"];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return @"治疗";
    else if(section == 2)
        return @"易发季节";
    else if (section == 3)
        return @"预防措施";
    else if(section == 4)
        return @"预后措施";
    return nil;
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
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
