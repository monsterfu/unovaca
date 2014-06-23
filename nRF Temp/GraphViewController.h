//
//  GraphViewController.h
//  nRF Temp
//
//  Created by Ole Morten on 10/19/12.
//
//

#import <UIKit/UIKit.h>

#import "TemperatureFob.h"

@interface GraphViewController : UIViewController <TemperatureFobDelegate>
@property (nonatomic, strong) TemperatureFob* fob;

@property (weak, nonatomic) IBOutlet UIView *graphView;

@end
