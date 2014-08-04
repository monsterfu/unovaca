//
//  ThreeDetailViewController.m
//  Unova Thermometer
//
//  Created by 符鑫 on 14-7-20.
//
//

#import "ThreeDetailViewController.h"

@interface ThreeDetailViewController ()

@end

@implementation ThreeDetailViewController

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
    
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = [_detailArray objectForKey:@"name"];
    _shiyong.text = [NSString stringWithFormat:@"%@%@\n%@%@\n%@%@",NSLocalizedString(@"[适用]: ", nil),[_detailArray objectForKey:@"intendPepole"],NSLocalizedString(@"[别名]: ", nil),[_detailArray objectForKey:@"comName"],NSLocalizedString(@"[评价]: ", nil),[_datailArray1 objectForKey:@"comment"]];
    _shiyong.textColor = [UIColor whiteColor];
    
    
    _textField = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.selectable = NO;
    _textField.editable = NO;
    _textField.scrollEnabled = NO;
    _textField.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@",[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[成分]: ", nil),[_detailArray objectForKey:@"ingredient"]],[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[用药人群]: ", nil),[_detailArray objectForKey:@"intendPepole"]],[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[禁忌]: ", nil),[_detailArray objectForKey:@"taboo"]],[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[不良反应]: ", nil),[_detailArray objectForKey:@"untowardEffect"]],[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[用法用量]: ", nil),[_detailArray objectForKey:@"usage"]],[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[适应症]: ", nil),[_detailArray objectForKey:@"adaptDisease"]],[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"[优点]: ", nil),[_detailArray objectForKey:@"advantage"]]];
    
    _textField1 = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
    _textField1.backgroundColor = [UIColor clearColor];
    _textField1.textColor = [UIColor blackColor];
    _textField1.font = [UIFont systemFontOfSize:12];
    _textField1.selectable = NO;
    _textField1.editable = NO;
    _textField1.scrollEnabled = NO;
    _textField1.text = [_detailArray objectForKey:@"attention"];
    
    
    
    size = [_textField.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT*2) lineBreakMode:NSLineBreakByWordWrapping];
    
    [_textField setFrame:CGRectMake(0, 0, DEVICE_WIDTH, size.height+60)];
    size1 = [_textField1.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT*2) lineBreakMode:NSLineBreakByWordWrapping];
    [_textField1 setFrame:CGRectMake(0, 0, DEVICE_WIDTH, size1.height+60)];
}
-(void)setNumber:(NSUInteger)number
{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 5, 200, 100)];
    NSLog(@"------%d",number +1);
    [_imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fuckZYQ%d",number+1]]];
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
#pragma mark - uitableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return size.height + 60;
    }else if (indexPath.section == 1){
        return size1.height + 60;
    }else{
        return 110;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* headerView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH, 146)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        headerView.text = NSLocalizedString(@"  基本信息", nil);
    }if (section == 1) {
        headerView.text = NSLocalizedString(@"  注意事项", nil);
    }else{
        headerView.text = NSLocalizedString(@"  ", nil);
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
indexPath
{
    UITableViewCell* cell;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"jibenxinxi"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jibenxinxi"];
            [cell addSubview:_textField];
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        }
    
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"zhuyishixiang"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zhuyishixiang"];
            [cell addSubview:_textField1];
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
            }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"zhaopian"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zhaopian"];
            [cell addSubview:_imageView];
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        }
    }
    return cell;
}
@end
