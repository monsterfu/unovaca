//
//  fourTableViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import <UIKit/UIKit.h>


@protocol fourTableViewControllerDelegate <NSObject>

-(void)fourTableCellDidSelected:(NSDictionary*)dic;

@end

@interface fourTableViewController : UITableViewController
{
    NSArray* _diseaseArray;
    id<fourTableViewControllerDelegate>delegate;
}

@property(nonatomic,assign)id<fourTableViewControllerDelegate>delegate;
@end
