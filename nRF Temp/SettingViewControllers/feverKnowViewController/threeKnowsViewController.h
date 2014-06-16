//
//  threeKnowsViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "threeView.h"

@interface threeKnowsViewController : UIViewController<UIScrollViewDelegate>
{
    threeView* _subView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
