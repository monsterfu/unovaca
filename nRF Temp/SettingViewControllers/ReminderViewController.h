


#import "PublicDefine.h"
#import "eventReminderCell.h"
#import "ReminderViewDetailController.h"

@interface ReminderViewController : UITableViewController<eventReminderCellDelegate>
{
    eventReminderCell* _eventCell;
    NSMutableArray* _allEventReminderModelArray;
    NSMutableArray* _allEventNoticationArray;
    
    
    UILocalNotification *_localNotice;
}
@end
