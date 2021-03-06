//
//  feverKnowsViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-29.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "oneKnowsViewController.h"
#import "twoKnowsViewController.h"
#import "threeKnowsViewController.h"
#import "fourTableViewController.h"
#import "fourDetalViewController.h"
#import "ThreeDetailViewController.h"

@interface feverKnowsViewController : UIViewController<fourTableViewControllerDelegate,threeKnowsViewControllerDelegate>
{
    NSDictionary* _knowsMutableDic;
    
    UIView* _oneView;
    UIView* _twoView;
    UIView* _threeView;
    UIView* _fourView;
    
    oneKnowsViewController* _oneKnowViewController;
    twoKnowsViewController* _twoKnowViewController;
    threeKnowsViewController* _threeKnowViewController;
    fourTableViewController* _fourKnowViewController;
    fourDetalViewController* _fourDetailViewController;
    
    ThreeDetailViewController* _threeDetailViewController;
    NSArray* _diseaseArray;
    NSArray* _dissarray1;
}

- (IBAction)segmentedControlSelected:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end
