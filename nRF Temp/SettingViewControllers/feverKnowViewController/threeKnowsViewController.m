//
//  threeKnowsViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import "threeKnowsViewController.h"

@interface threeKnowsViewController ()

@end


#define CELLVIEW_WIDTH  (160)
#define CELLVIEW_HEIGHT  (87)

@implementation threeKnowsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor grayColor];
    NSLog(@"scrollView content size:%f,%f,_scrollView.frame:%f,%f,%f,%f",_scrollView.contentSize.width,_scrollView.contentSize.height,_scrollView.frame.origin.x,_scrollView.frame.origin.y,_scrollView.frame.size.width,_scrollView.frame.size.height);
    [_scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height*2)];
    [_scrollView setContentOffset:CGPointMake(0, 100)];
    NSLog(@"scrollView content size:%f,%f,_scrollView.frame:%f,%f,%f,%f",_scrollView.contentSize.width,_scrollView.contentSize.height,_scrollView.frame.origin.x,_scrollView.frame.origin.y,_scrollView.frame.size.width,_scrollView.frame.size.height);
    
    for (UIView* views in [_scrollView subviews]) {
        NSLog(@"%@",views);
        if ([views isKindOfClass:[UIImageView class]]) {
            [views removeFromSuperview];
        }
        if ([views isKindOfClass:[threeView class]]) {
            threeView* viewR = (threeView*)views;
            viewR.delegate = self;
        }
    }
    
    
}


-(NSString*)getCorrectStrData:(NSString*)inputString
//- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"scrollViewWillEndDragging");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}

#pragma mark - delegate

-(void)threeViewTouched:(NSUInteger)index
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(threeKnowsViewTouch:)]) {
        [self.delegate threeKnowsViewTouch:index];
    }
}
@end
