//
//  PersonListViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-3.
//
//

#import <UIKit/UIKit.h>
#import "PersonInfoCell.h"
#import "PersonDetailInfo.h"
#import "PersonViewController.h"

@interface PersonListViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{
    PersonInfoCell* _personInfoCell;
//    PersonDetailInfo* _detailInfo;
    NSUInteger _selectedIndex;
    
    UIImageView* _selectView;
}
@property(nonatomic,retain)PersonDetailInfo* detailInfo;
@property(nonatomic,retain)NSMutableArray* personFobsArray;
@property(nonatomic,retain)NSMutableArray* personInfoArray;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
