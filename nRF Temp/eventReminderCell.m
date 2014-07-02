//
//  eventReminderCell.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "eventReminderCell.h"


@implementation eventReminderCell

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
    if (self.delegate&&[self.delegate respondsToSelector:@selector(switchChanged:index:)]) {
        [self.delegate switchChanged:sender.on index:[_eventReminderModel.index intValue]];
    }
}

-(void)setEventReminderModel:(EventReminderModel *)eventReminderModel
{
    _eventReminderModel = eventReminderModel;
    
    _eventContentLabel.text = eventReminderModel.eventContent;
    
    NSDate* date = [NSDate dateWithTimeInterval:8*60*60 sinceDate:eventReminderModel.time];
    NSString* dateStr = [[date.description substringToIndex:16]substringFromIndex:11];
    
//    NSString* dateStr = [[[eventReminderModel.time description] substringToIndex:16]substringFromIndex:11];
    
    _timeLabel.text = dateStr;
    if ([eventReminderModel.repeat intValue]) {
        _frequenceLabel.text = NSLocalizedString(@"每天提醒",nil);
    }else{
        _frequenceLabel.text = NSLocalizedString(@"提醒一次",nil);
    }
    _smallContentLabel.text = eventReminderModel.eventContent;
    
    if ([eventReminderModel.open boolValue]) {
        _switchView.on = YES;
    }else{
        _switchView.on = NO;
    }
    
    
}
@end
