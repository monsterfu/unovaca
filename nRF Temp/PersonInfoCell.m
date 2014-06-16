//
//  PersonInfoCell.m
//  nRF Temp
//
//  Created by Monster on 14-3-31.
//
//

#import "PersonInfoCell.h"

@implementation PersonInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headButtonTouched:(UIButton *)sender {
    NSLog(@"headButtonTouched");
}

+(NSString*)fromDateToAge:(NSDate*)date{
    NSDate *myDate = date;
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    int year = [comps year];
    return [NSString stringWithFormat:@"%d岁",year];
}

-(void)setCellWithPersonDetailInfo:(PersonDetailInfo*)info
{
    _personInfoAgeLabel.text = [PersonInfoCell fromDateToAge:info.birthday];
    
    [_personInfoHeadImageView.layer setCornerRadius:CGRectGetHeight([_personInfoHeadImageView bounds]) / 2];
    _personInfoHeadImageView.layer.masksToBounds = YES;
    [_personInfoHeadImageView setImage:info.image];
    
    _personInfoNameLabel.text = info.name;
    _personInfoWeightLabel.text = [NSString stringWithFormat:@"%dkg",[info.weight intValue]];
}
-(void)setDetailInfo:(PersonDetailInfo *)detailInfo
{
    if (_detailInfo != detailInfo) {
        _detailInfo = detailInfo;
        [self setCellWithPersonDetailInfo:detailInfo];
    }
    
}
@end
