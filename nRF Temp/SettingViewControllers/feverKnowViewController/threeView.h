//
//  threeView.h
//  nRF Temp
//
//  Created by 符鑫 on 14-5-7.
//
//

#import <UIKit/UIKit.h>


@protocol threeViewDelegate <NSObject>
-(void)threeViewTouched:(NSUInteger)index;
@end

@interface threeView : UIView

@property(nonatomic,assign)id<threeViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *pingjia;
@property (weak, nonatomic) IBOutlet UILabel *last;

@end
