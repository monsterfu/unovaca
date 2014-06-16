//
//  oneKnowsViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-7.
//
//

#import "oneKnowsViewController.h"

@interface oneKnowsViewController ()

@end

@implementation oneKnowsViewController

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
    _titleArray = @[@"腋温(37℃以上算发烧)",@"耳温(38℃以上算发烧)",@"口温(38℃以上算发烧)",@"额温(38℃以上算发烧)",@"肛温(37.5℃以上算发烧)"];
    _contentArray = @[@"平均测量值低于中心体温约0.8℃,37℃以上算发烧.一般玻璃制水银体温计要测量3-10分钟读取数据.本产品适用测量腋温,连续测量无需取出体温计.",@"由于耳膜位于头骨肉接近体温调节中枢-下视区的位置,且与颈动脉的血流相通,所以量耳温可以说是人体中的中心体温.但三月以下婴儿与中心体温关系不大,不建议使用.",@"口温平均值低于中心体温约0.5℃.测量口温需要宝宝配合,不适合较小婴儿使用.禁止使用玻璃制水银温度计测量口温,以免温度计破裂发生意外.注意测量前15分钟不要饮用热/冷水以免出现误差.",@"在额头测量表皮温度时,均有低于中心体温的现象.一般额温枪比较容易受环境因素干扰,测量时多注意探头与皮肤表面的距离,室温变化等因素.请在10℃-40℃环境温度下测量",@"肛温与中心温度接近.清洁体温计后伸入肛门1.5至2.5厘米,测量温度38℃以上算发烧"];
    
//    _label1.text = [_titleArray objectAtIndex:0];
//    _label2.text = [_titleArray objectAtIndex:1];
//    _label3.text = [_titleArray objectAtIndex:2];
//    _label4.text = [_titleArray objectAtIndex:3];
//    _label5.text = [_titleArray objectAtIndex:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
