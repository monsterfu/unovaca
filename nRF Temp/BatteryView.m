//
//  BatteryLabel.m
//  MasterDetailContainerTest
//
//  Created by Ole Morten on 9/11/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "BatteryView.h"

@interface BatteryBackgroundView : UIView
@end

@implementation BatteryBackgroundView
- (void) drawRect:(CGRect)rect
{
    CGFloat borderWidth = rect.size.height*0.05;
    CGFloat connectorHeight = rect.size.height*0.5;
    CGFloat connectorWidth = connectorHeight*0.5;
    
    [[UIColor whiteColor] setStroke];
    [[UIColor blackColor] setFill];
    
    CGRect batteryRect = CGRectMake(borderWidth, borderWidth, rect.size.width-borderWidth*2-connectorWidth, rect.size.height-borderWidth*2);
    UIBezierPath *battery = [UIBezierPath bezierPathWithRect:batteryRect];
    [battery setLineWidth:borderWidth];
    [battery stroke];
    [battery fill];
    
    CGRect connectorRect = CGRectMake(rect.size.width-connectorWidth-borderWidth*0.5, rect.size.height*0.5-connectorHeight*0.5-borderWidth*0.5, connectorWidth, connectorHeight);
    UIBezierPath *connector = [UIBezierPath bezierPathWithRect:connectorRect];
    [connector setLineWidth:borderWidth];
    [connector stroke];
    [connector fill];
    
    [super drawRect:rect];
}
@end

@interface BatteryView ()
@property BatteryBackgroundView *backgroundView;
@property UILabel *batteryLabel;
@end

@implementation BatteryView
@synthesize backgroundView = _backgroundView;
@synthesize batteryLabel = _batteryLabel;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _backgroundView = [[BatteryBackgroundView alloc] initWithFrame:rect];
        [_backgroundView setOpaque:NO];
        
        rect.size.width = rect.size.width-5;
        _batteryLabel = [[UILabel alloc] initWithFrame:rect];
        _batteryLabel.backgroundColor = [UIColor clearColor];
        _batteryLabel.adjustsFontSizeToFitWidth = YES;
        _batteryLabel.text = @"- %";
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
        _batteryLabel.textColor = [UIColor whiteColor];
        _batteryLabel.font = [UIFont boldSystemFontOfSize:self.frame.size.height*0.5];
        
        [self insertSubview:_backgroundView atIndex:0];
        [self insertSubview:_batteryLabel atIndex:1];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) setBatteryLevel:(NSNumber *)level
{
    [self.batteryLabel setText:[NSString stringWithFormat:@"%d %%", level.intValue]];
}

@end
