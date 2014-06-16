//
//  feverKnowsViewController.m
//  nRF Temp
//
//  Created by Monster on 14-4-29.
//
//

#import "feverKnowsViewController.h"

@interface feverKnowsViewController ()

@end

#define BOTTOM_HEIGHT  (475)

@implementation feverKnowsViewController

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
    // Do any additional setup after loading the view.
    
    _oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, BOTTOM_HEIGHT)];
    _oneView.backgroundColor = [UIColor clearColor];
    _twoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, BOTTOM_HEIGHT)];
    _twoView.backgroundColor = [UIColor clearColor];
    _threeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, BOTTOM_HEIGHT)];
    _threeView.backgroundColor = [UIColor clearColor];
    _fourView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, BOTTOM_HEIGHT)];
    _fourView.backgroundColor = [UIColor clearColor];
    
    
    _oneKnowViewController = [[oneKnowsViewController alloc]initWithNibName:@"oneKnowsViewController" bundle:nil];
    [_oneView addSubview:_oneKnowViewController.view];
    
    _twoKnowViewController = [[twoKnowsViewController alloc]initWithNibName:@"twoKnowsViewController" bundle:nil];
    [_twoView addSubview:_twoKnowViewController.view];
    
    _threeKnowViewController = [[threeKnowsViewController alloc]initWithNibName:@"threeKnowsViewController" bundle:nil];
    [_threeView addSubview:_threeKnowViewController.view];
    
    _fourKnowViewController = [[fourTableViewController alloc]initWithNibName:@"fourTableViewController" bundle:nil];
    _fourKnowViewController.delegate = self;
    [_fourView addSubview:_fourKnowViewController.view];
    
    
    [self.view addSubview:_oneView];
    [self.view addSubview:_twoView];
    [self.view addSubview:_threeView];
    [self.view addSubview:_fourView];
    
    
    [_oneView setHidden:NO];
    [_twoView setHidden:YES];
    [_threeView setHidden:YES];
    [_fourView setHidden:YES];
    [self.view bringSubviewToFront:_segmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentedControlSelected:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [_oneView setHidden:NO];
            [_twoView setHidden:YES];
            [_threeView setHidden:YES];
            [_fourView setHidden:YES];
        }
            break;
        case 1:
        {
            [_oneView setHidden:YES];
            [_twoView setHidden:NO];
            [_threeView setHidden:YES];
            [_fourView setHidden:YES];
        }
            break;
        case 2:
        {
            [_oneView setHidden:YES];
            [_twoView setHidden:YES];
            [_threeView setHidden:NO];
            [_fourView setHidden:YES];
        }
            break;
        case 3:
        {
            [_oneView setHidden:YES];
            [_twoView setHidden:YES];
            [_threeView setHidden:YES];
            [_fourView setHidden:NO];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark --
-(void)fourTableCellDidSelected:(NSDictionary *)dic
{
    _fourDetailViewController = [[fourDetalViewController alloc]initWithNibName:@"fourDetalViewController" bundle:nil dic:dic];
    
    [self.navigationController pushViewController:_fourDetailViewController animated:YES];
    
}
@end
