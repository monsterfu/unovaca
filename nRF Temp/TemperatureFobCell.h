//
//  TemperatureCell.h
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import <UIKit/UIKit.h>

#import "TemperatureFob.h"


@protocol TemperatureFobCellDelegate <NSObject>

-(void)selectedFobButtonTouched:(TemperatureFob*)fob;

@end

@interface TemperatureFobCell : UITableViewCell
{
    id<TemperatureFobCellDelegate>delegate;
    TemperatureFob* _fob;
}

@property (weak, nonatomic) id<TemperatureFobCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signalImageView;


- (IBAction)selectedButtonTouch:(UIButton *)sender;

- (void) setFob:(TemperatureFob*) fob;

@end
