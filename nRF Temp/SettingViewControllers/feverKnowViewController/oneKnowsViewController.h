//
//  oneKnowsViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import <UIKit/UIKit.h>

@interface oneKnowsViewController : UIViewController
{
    NSArray* _titleArray;
    NSArray* _contentArray;
}


@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@property (weak, nonatomic) IBOutlet UILabel *content1;
@property (weak, nonatomic) IBOutlet UILabel *content2;
@property (weak, nonatomic) IBOutlet UILabel *content3;
@property (weak, nonatomic) IBOutlet UILabel *content4;
@property (weak, nonatomic) IBOutlet UILabel *content5;

//@property (weak, nonatomic) IBOutlet UIView *fuckZYQ;


@end
