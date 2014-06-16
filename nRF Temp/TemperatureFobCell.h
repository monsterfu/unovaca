//
//  TemperatureCell.h
//  nRF Temp
//
//  Created by Ole Morten on 10/16/12.
//
//

#import <UIKit/UIKit.h>

#import "TemperatureFob.h"

@interface TemperatureFobCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signalImage;
@property (weak, nonatomic) IBOutlet UILabel *w;

- (void) setFob:(TemperatureFob*) fob;

@end
