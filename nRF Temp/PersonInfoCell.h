//
//  PersonInfoCell.h
//  nRF Temp
//
//  Created by Monster on 14-3-31.
//
//

#import <UIKit/UIKit.h>
#import "PersonDetailInfo.h"
#import <QuartzCore/QuartzCore.h>

@interface PersonInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *personInfoHeadButton;
@property (weak, nonatomic) IBOutlet UIImageView *personInfoHeadImageView;
@property (strong, nonatomic) IBOutlet UILabel *personInfoNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *personInfoAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *personInfoWeightLabel;

@property (nonatomic, strong) PersonDetailInfo *detailInfo;
- (IBAction)headButtonTouched:(UIButton *)sender;

-(void)setCellWithPersonDetailInfo:(PersonDetailInfo*)info;
@end
