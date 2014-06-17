//
//  eventContentViewCell.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "eventContentViewCell.h"

@implementation eventContentViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _textField.delegate = self;
    // Configure the view for the selected state
}

#pragma mark - textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(updateTextField:)]) {
            [self.delegate updateTextField:textField.text];
            [textField resignFirstResponder];
        }
        return YES;
    }
    return YES;
}
@end
