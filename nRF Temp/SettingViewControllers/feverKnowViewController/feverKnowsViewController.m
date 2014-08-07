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
    
    self.title = NSLocalizedString(@"发烧一点通", nil);
    _oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, BOTTOM_HEIGHT)];
    _oneView.backgroundColor = [UIColor clearColor];
    _twoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, BOTTOM_HEIGHT)];
    _twoView.backgroundColor = [UIColor clearColor];
    _threeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, BOTTOM_HEIGHT)];
    _threeView.backgroundColor = [UIColor clearColor];
    _fourView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, BOTTOM_HEIGHT)];
    _fourView.backgroundColor = [UIColor clearColor];
    
    
    _oneKnowViewController = [[oneKnowsViewController alloc]initWithNibName:@"oneKnowsViewController" bundle:nil];
    [_oneView addSubview:_oneKnowViewController.view];
    
    _twoKnowViewController = [[twoKnowsViewController alloc]initWithNibName:@"twoKnowsViewController" bundle:nil];
    [_twoView addSubview:_twoKnowViewController.view];
    
    _threeKnowViewController = [[threeKnowsViewController alloc]initWithNibName:@"threeKnowsViewController" bundle:nil];
    _threeKnowViewController.delegate = self;
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
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    
    NSError* error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"medicine-2" ofType:nil];
    NSString *jsonData = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    NSString* dataStr = [self getCorrectStrData:jsonData];
    NSData* datttt = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    _diseaseArray = [NSJSONSerialization JSONObjectWithData:datttt options:NSJSONReadingMutableContainers error:&error];
    
    jsonPath = [[NSBundle mainBundle] pathForResource:@"medicine_card" ofType:nil];
    jsonData = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    dataStr = [self getCorrectStrData:jsonData];
    datttt = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    _dissarray1 = [NSJSONSerialization JSONObjectWithData:datttt options:NSJSONReadingMutableContainers error:&error];
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

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - 
-(void)threeKnowsViewTouch:(NSUInteger)index
{
    _threeDetailViewController = [[ThreeDetailViewController alloc]initWithNibName:@"ThreeDetailViewController" bundle:nil];
    if (index == 9||index == 10||index == 11) {
        _threeDetailViewController.detailArray = [_diseaseArray objectAtIndex:index+1];
    }else{
        _threeDetailViewController.detailArray = [_diseaseArray objectAtIndex:index];
    }
    _threeDetailViewController.datailArray1 = [_dissarray1 objectAtIndex:index];
    _threeDetailViewController.number = index;
    [self.navigationController pushViewController:_threeDetailViewController animated:YES];
}

@end
