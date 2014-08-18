//
//  fourDetalViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import <UIKit/UIKit.h>
#import "UIImage+scaleToSize.h"
#import "PublicDefine.h"

@interface fourDetalViewController : UIViewController
{
    NSMutableArray* _contentArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, retain)NSDictionary* contentDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dic:(NSDictionary*)dic;
@end
