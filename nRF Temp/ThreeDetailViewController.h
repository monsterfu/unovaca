//
//  ThreeDetailViewController.h
//  Unova Thermometer
//
//  Created by 符鑫 on 14-7-20.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"



@interface ThreeDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITextView* _textField;
    NSString* _text;
    CGSize  size;
    
    UITextView* _textField1;
    UIImageView* _imageView;
    NSString* _text1;
    CGSize  size1;
    
    
}

@property(nonatomic, retain)NSDictionary* detailArray;
@property(nonatomic, retain)NSDictionary* datailArray1;
@property(nonatomic, assign)NSUInteger number;


@property (weak, nonatomic) IBOutlet UITextView *shiyong;
@property (weak, nonatomic) IBOutlet UITextView *bieming;
@property (weak, nonatomic) IBOutlet UITextView *pingjia;

@property (weak, nonatomic) IBOutlet UITableView *tableView;






@end
