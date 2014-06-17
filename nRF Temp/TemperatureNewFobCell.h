//
//  TemperatureNewFobCell.h
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import <UIKit/UIKit.h>

#import "TemperatureFob.h"

@interface TemperatureNewFobCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *signalImageView;
@property (weak, nonatomic) IBOutlet UILabel *fobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

- (void) setFob:(TemperatureFob*) fob;
@end
