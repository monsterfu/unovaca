//
//  eventRepeatViewCell.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "eventRepeatViewCell.h"

@implementation eventRepeatViewCell

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

    // Configure the view for the selected state
}

- (IBAction)switchChanged:(UISwitch *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(repeatRemindisOpen:)]) {
        [self.delegate repeatRemindisOpen:sender.isOn];
    }
}
@end
