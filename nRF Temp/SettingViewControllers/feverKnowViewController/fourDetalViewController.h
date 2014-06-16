//
//  fourDetalViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import <UIKit/UIKit.h>

@interface fourDetalViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *top;
@property (weak, nonatomic) IBOutlet UILabel *zhiliao;
@property (weak, nonatomic) IBOutlet UILabel *yifajijie;
@property (weak, nonatomic) IBOutlet UILabel *yufangcuoshi;


@property(nonatomic, retain)NSDictionary* contentDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dic:(NSDictionary*)dic;
@end
