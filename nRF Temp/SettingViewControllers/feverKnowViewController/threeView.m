//
//  threeView.m
//  nRF Temp
//
//  Created by 符鑫 on 14-5-7.
//
//

#import "threeView.h"

@implementation threeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded,self.tag:%d",self.tag);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(threeViewTouched:)]) {
        [self.delegate threeViewTouched:self.tag];
    }
}
@end
