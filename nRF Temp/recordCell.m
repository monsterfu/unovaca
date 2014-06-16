//
//  recordCell.m
//  nRF Temp
//
//  Created by 符鑫 on 14-5-11.
//
//

#import "recordCell.h"

@implementation recordCell

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

-(CGFloat)hightestTempInArray:(NSArray*)arry
{
    CGFloat tem = 0;
    
    TemperatureReading* firstReading = [arry objectAtIndex:0];
    tem = [firstReading.value floatValue];
    
    for (TemperatureReading* obj in arry) {
        if ([obj.value floatValue] > tem) {
            tem = [obj.value floatValue];
        }
    }
    return tem;
}

-(void)setRecordReadingArrayWithArray:(NSArray *)recordReadingArray
{
    if (self.recordReadingArray != recordReadingArray) {
        self.recordReadingArray = [NSArray arrayWithArray:recordReadingArray];
    }
    self.tempLabel.text = [NSString stringWithFormat:@"%.1f℃",[self hightestTempInArray:recordReadingArray]];
    
    TemperatureReading* reading = [recordReadingArray objectAtIndex:0];
    self.dateLabel.text = [NSString stringWithFormat:@"%d日",[reading.date day]];
    
    reading = [recordReadingArray lastObject];
    self.finishLabel.text = [NSString stringWithFormat:@"%.1f℃",[reading.value floatValue]];
    
}
@end
