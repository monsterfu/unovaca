//
//  eventRepeatViewCell.h
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import <UIKit/UIKit.h>

@protocol eventRepeatViewCellDelegate <NSObject>

-(void)repeatRemindisOpen:(BOOL)on;

@end

@interface eventRepeatViewCell : UITableViewCell
{
    id<eventRepeatViewCellDelegate>delegate;
}
@property (weak, nonatomic)id<eventRepeatViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
- (IBAction)switchChanged:(UISwitch *)sender;
@end
