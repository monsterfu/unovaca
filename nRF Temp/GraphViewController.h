//
//  GraphViewController.h
//  nRF Temp
//
//  Created by Ole Morten on 10/19/12.
//
//

#import <UIKit/UIKit.h>

#import "TemperatureFob.h"

@interface GraphViewController : UIViewController <TemperatureFobDelegate, CPTPlotDataSource, CPTPlotSpaceDelegate>
@property (nonatomic, strong) TemperatureFob* fob;

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTGraph *graph;

@property (weak, nonatomic) IBOutlet UIView *graphView;

@end
