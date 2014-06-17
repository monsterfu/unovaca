//
//  eventContentViewCell.h
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import <UIKit/UIKit.h>

@protocol eventContentViewCellDelegate <NSObject>

-(void)updateTextField:(NSString*)content;

@end

@interface eventContentViewCell : UITableViewCell<UITextFieldDelegate>
{
    id<eventContentViewCellDelegate>delegate;
}
@property (weak, nonatomic) id<eventContentViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
