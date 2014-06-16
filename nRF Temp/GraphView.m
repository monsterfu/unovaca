//
//  GraphView.m
//  nRF Temp
//
//  Created by Monster on 14-5-16.
//
//

#import "GraphView.h"

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context,  1, 1, 1, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextSetLineWidth(context, 3.0);//线的宽度
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/3, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
}


@end
