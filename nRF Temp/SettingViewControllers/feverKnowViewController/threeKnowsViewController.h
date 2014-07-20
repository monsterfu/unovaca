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

@protocol threeKnowsViewControllerDelegate <NSObject>
-(void)threeKnowsViewTouch:(NSUInteger)index;
@end

@interface threeKnowsViewController : UIViewController<UIScrollViewDelegate,threeViewDelegate>
{
    threeView* _subView;
}

@property (nonatomic, assign)id<threeKnowsViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;




@end
