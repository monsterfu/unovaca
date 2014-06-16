//
//  NewGraphViewController.h
//  nRF Temp
//
//  Created by Monster on 14-5-16.
//
//

#import <UIKit/UIKit.h>
#import "TemperatureFob.h"
#import "PublicDefine.h"
#import "GraphView.h"
#import "GraphViewController.h"

@interface NewGraphViewController : UIViewController
{
    NSDate* _firstDate;
    NSDate* _lastDate;
    NSTimeInterval _timeGap;
    CGRect _graphRect;
}

@property(nonatomic, retain)NSString* dateStr;
@property (nonatomic, strong) TemperatureFob* fob;
@property (strong, nonatomic)NSArray* readings;

@property (weak, nonatomic) IBOutlet UILabel *MostTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tempBgImage;

@property (weak, nonatomic) IBOutlet UILabel *time1Label;
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
@property (weak, nonatomic) IBOutlet UILabel *time3Label;
@property (weak, nonatomic) IBOutlet UILabel *time4Label;
@property (weak, nonatomic) IBOutlet UILabel *time5Label;



@end
