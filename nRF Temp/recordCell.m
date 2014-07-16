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

-(NSString*)getStatusString:(CGFloat)value
{
    if (value >= 34.5&&value< 36) {
        return NSLocalizedString(@"低温",nil);
    }else if (value >= 36&&value< 37.5) {
        return NSLocalizedString(@"正常",nil);
    }else if (value >= 37.5&&value< 38) {
        return NSLocalizedString(@"低热",nil);
    }else if (value >= 38&&value< 39) {
        return NSLocalizedString(@"中热",nil);
    }else if (value >= 39&&value < 40) {
        return NSLocalizedString(@"高热",nil);
    }else if (value >= 40) {
        return NSLocalizedString(@"超高热",nil);
    }else
        return NSLocalizedString(@"异常",nil);
}

-(void)setRecordReadingArrayWithArray:(NSArray *)recordReadingArray
{
    if (self.recordReadingArray != recordReadingArray) {
        self.recordReadingArray = [NSArray arrayWithArray:recordReadingArray];
    }
    
    CGFloat temp = [self hightestTempInArray:recordReadingArray];
    
    if (temp< 31.0) {
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_35"]];
    }else if (temp >= 31&&temp< 34.5) {
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_35"]];
    }else if (temp >= 34.5&&temp< 36) {
        [_statusLabel setTextColor:[UIColor blackColor]];
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_35"]];
    }else if (temp >= 36&&temp< 37.5) {
        [_statusLabel setTextColor:[UIColor yellowColor]];
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_37"]];
    }else if (temp >= 37.5&&temp< 38) {
        [_statusLabel setTextColor:[UIColor orangeColor]];
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_38"]];
    }else if (temp >= 38&&temp< 39) {
        [_statusLabel setTextColor:[UIColor orangeColor]];
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_39"]];
    }else if (temp >= 39&&temp < 40) {
        [_statusLabel setTextColor:[UIColor redColor]];
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_41"]];
    }else if (temp >= 40) {
        [_statusLabel setTextColor:[UIColor redColor]];
        [_statusImageView setImage:[UIImage imageNamed:@"ic_number_status_45"]];
    }
    
    self.tempLabel.text = [NSString stringWithFormat:@"%.1f℃",[self hightestTempInArray:recordReadingArray]];
    
    self.statusLabel.text = [self getStatusString:[self hightestTempInArray:recordReadingArray]];
    
    TemperatureReading* reading = [recordReadingArray objectAtIndex:0];
    self.dateLabel.text = [NSString stringWithFormat:@"%d日",[reading.date day]];
    
    reading = [recordReadingArray lastObject];
    self.finishLabel.text = [NSString stringWithFormat:@"%.1f℃",[reading.value floatValue]];
    
}
@end
