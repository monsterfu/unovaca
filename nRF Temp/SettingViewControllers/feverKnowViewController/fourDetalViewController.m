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
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
