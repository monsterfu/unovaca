//
//  fourDetalViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import "fourDetalViewController.h"

@interface fourDetalViewController ()

@end

@implementation fourDetalViewController

#define  str_yfrq   @"[易发人群]:"
#define  str_cjzz   @"[常见症状]:"
#define  str_js     @"[介绍]:"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dic:(NSDictionary*)dic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contentDic = dic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setContent:_contentDic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setContent:(NSDictionary *)contentDic
{
    self.title = [contentDic objectForKey:@"name"];
        
    _top.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",str_yfrq,[contentDic objectForKey:@"incidentCrowd"],str_cjzz,[contentDic objectForKey:@"commonSymptom"],str_js,[contentDic objectForKey:@"desc"]];
    
    _zhiliao.text = [contentDic objectForKey:@"treatment"];
    
    _yifajijie.text = [contentDic objectForKey:@"incidentSeason"];
    
    _yufangcuoshi.text = [contentDic objectForKey:@"precautionarMeasures"];
    
}
@end
