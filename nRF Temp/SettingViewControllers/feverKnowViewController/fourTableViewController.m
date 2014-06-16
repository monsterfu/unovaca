//
//  fourTableViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import "fourTableViewController.h"

@interface fourTableViewController ()

@end

@implementation fourTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError* error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"disease" ofType:nil];
    NSString *jsonData = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    NSString* dataStr = [self getCorrectStrData:jsonData];
    NSData* datttt = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    _diseaseArray = [NSJSONSerialization JSONObjectWithData:datttt options:NSJSONReadingMutableContainers error:&error];
}


-(NSString*)getCorrectStrData:(NSString*)inputString
//- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_diseaseArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diseaseCell"];//[tableView dequeueReusableCellWithIdentifier:@"diseaseCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    cell.textLabel.text = [[_diseaseArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
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
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(fourTableCellDidSelected:)]) {
        [self.delegate fourTableCellDidSelected:[_diseaseArray objectAtIndex:indexPath.row]];
    }
}


@end
