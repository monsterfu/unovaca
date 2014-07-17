//
//  PersonListViewController.m
//  nRF Temp
//
//  Created by Monster on 14-4-3.
//
//

#import "PersonListViewController.h"
#import "AppDelegate.h"
@interface PersonListViewController ()

@end

@implementation PersonListViewController

// segue ID when "+" button is tapped
static NSString *kShowRecipeSegueID = @"oldPersonDetail";

// segue ID when "Add Ingredient" cell is tapped
static NSString *kAddPersonSegueID = @"firstPersonDetail";

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _personInfoArray = [PersonDetailInfo allPersonDetail];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    _selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [_selectView setImage:[UIImage imageNamed:@"single_item_selector_icon_normal.png"]];
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
-(void)viewWillAppear:(BOOL)animated
{
    _personInfoArray = [PersonDetailInfo allPersonDetail];
    
    NSUInteger i = 0;
    
    for (PersonDetailInfo* person in _personInfoArray) {
        if ([person.personId isEqualToString:[USER_DEFAULT objectForKey:KEY_PERSONID]]) {
            _selectedIndex = i;
        }
        i++;
    }
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_personInfoArray count] == 0) {
        return NSLocalizedString(@"无用户信息，请添加",nil);
    }
    return NSLocalizedString(@"点击头像，详细编辑",nil);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
	
    if ([self.fetchedResultsController sections].count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
//    if (numberOfRows == 0) {
//        [self performSegueWithIdentifier:kAddPersonSegueID sender:nil];
//    }
    numberOfRows = [_personInfoArray count];
    return numberOfRows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_personInfoCell) {
        return _personInfoCell.frame.size.height;
    }
    else return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _personInfoCell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:_personInfoCell atIndexPath:indexPath];
    if (indexPath.row == _selectedIndex) {
//        _personInfoCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _personInfoCell.accessoryView = _selectView;
    }
    
    
    return _personInfoCell;
}

- (void)configureCell:(PersonInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
	PersonDetailInfo *detailInfo = (PersonDetailInfo *)[_personInfoArray objectAtIndex:indexPath.row];
    cell.detailInfo = detailInfo;
    cell.personInfoHeadButton.tag = indexPath.row;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PersonDetailInfo *detailInfo = (PersonDetailInfo *)[_personInfoArray objectAtIndex:indexPath.row];
//
    NSLog(@"indexPath.row:%d",indexPath.row);
    [USER_DEFAULT removeObjectForKey:KEY_PERSON_SELECTED];
    [USER_DEFAULT setInteger:indexPath.row forKey:KEY_PERSON_SELECTED];
    [USER_DEFAULT synchronize];
    
    
    PersonDetailInfo *detailInfo = (PersonDetailInfo *)[_personInfoArray objectAtIndex:indexPath.row];
    [USER_DEFAULT removeObjectForKey:KEY_PERSONID];
    [USER_DEFAULT setObject:detailInfo.personId forKey:KEY_PERSONID];
    [USER_DEFAULT synchronize];
    
    
    NSUInteger index = _selectedIndex;
    _selectedIndex = indexPath.row;
    NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    // Deselect the row.
    //                _detailInfo.blood = [NSNumber numberWithInteger:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([tableView numberOfRowsInSection:0] <= 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:NSLocalizedString(@"人员信息不可为空",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"好的",nil) otherButtonTitles:nil, nil];
            [alertView show];
            [tableView setEditing:NO animated:YES];
            return;
        }
        [PersonDetailInfo deletePerson:(PersonDetailInfo *)[_personInfoArray objectAtIndex:indexPath.row]];
        [_personInfoArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kShowRecipeSegueID]) {
//        _detailInfo = (PersonDetailInfo *)[[PersonDetailInfo allPersonFobs]objectAtIndex:sender.tag]
        UIButton* testButton = sender;
        NSLog(@"%@ %d",testButton, testButton.tag);
        _detailInfo = (PersonDetailInfo *)[_personInfoArray objectAtIndex:testButton.tag];
        PersonViewController *oldController = (PersonViewController *)segue.destinationViewController;
        oldController.detailInfo = _detailInfo;
        oldController.isNew = NO;
    }
    else if ([segue.identifier isEqualToString:kAddPersonSegueID]) {
        // add a recipe
        
        [USER_DEFAULT removeObjectForKey:KEY_NICKNAME_STR];
        
        _detailInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PersonDetailInfo"
                                                    inManagedObjectContext:self.managedObjectContext];
        _detailInfo.personId = [NSString randomStr];
        _detailInfo.image = [UIImage imageNamed:@"default_head"];
        _detailInfo.birthday = [NSDate dateWithTimeIntervalSinceNow:-2*365*24*60*60];
        _detailInfo.weight = [NSNumber numberWithFloat:14.0f];
        PersonViewController *addController = (PersonViewController *)segue.destinationViewController;
        addController.detailInfo = _detailInfo;
        addController.isNew = YES;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    return nil;
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = delegate.managedObjectContext;
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonDetailInfo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
//        fetchRequest = [delegate.managedObjectModel fetchRequestTemplateForName:@"PersonFobs"];
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
    }
	
	return _fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
            [self configureCell:(PersonInfoCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//			[self configureCell:(RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
	// The fetch controller has sent all current change notifications,
    // so tell the table view to process all updates.
	[self.tableView endUpdates];
}
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
