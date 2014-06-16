//
//  NewGraphViewController.m
//  nRF Temp
//
//  Created by Monster on 14-5-16.
//
//

#import "NewGraphViewController.h"

@interface NewGraphViewController ()

@end

@implementation NewGraphViewController

#define TEM_W_H   (18)


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
    
    TemperatureReading* reading = [_readings objectAtIndex:0];
    _dateStr = [NSString stringWithFormat:@"%d月%d日",[reading.date month],[reading.date day]];
    
    NSString* titleStr = @"宝贝体温记录";
    self.title = [titleStr stringByAppendingString:[NSString stringWithFormat:@"(%@)",_dateStr]];
    
    _MostTempLabel.text = [NSString stringWithFormat:@"最高温度%.1f℃",[self hightestTempInArray:_readings]];
    
    _graphRect = CGRectMake(_tempBgImage.frame.origin.x + 48, _tempBgImage.frame.origin.y, _tempBgImage.frame.size.width-80, _tempBgImage.frame.size.height);
    [self firstAndLastDate:_readings];
    
    [self processTimeLabel];
    
    [self processTemperatureLabel];
    
}
-(NSString*)timeStrFromReading:(TemperatureReading*)reading
{
    return [NSString stringWithFormat:@"%02d:%02d",[reading.date hour],[reading.date minute]];
}
-(NSString*)timeStrFromDate:(NSDate*)date
{
    return [NSString stringWithFormat:@"%02d:%02d",[date hour],[date minute]];
}

-(void)processTimeLabel
{
    switch ([_readings count]) {
        case 1:
        {
            _time1Label.text = @"";
            _time2Label.text = @"";
            _time3Label.text = [self timeStrFromReading:[_readings objectAtIndex:0]];
            _time4Label.text = @"";
            _time5Label.text = @"";
        }
            break;
        case 2:
        {
            _time1Label.text = [self timeStrFromReading:[_readings objectAtIndex:0]];
            _time2Label.text = @"";
            _time3Label.text = @"";
            _time4Label.text = @"";
            _time5Label.text = [self timeStrFromReading:[_readings objectAtIndex:1]];
        }
            break;
        case 3:
        {
            _time1Label.text = [self timeStrFromReading:[_readings objectAtIndex:0]];
            _time2Label.text = @"";
            _time3Label.text = [self timeStrFromReading:[_readings objectAtIndex:1]];
            _time4Label.text = @"";
            _time5Label.text = [self timeStrFromReading:[_readings objectAtIndex:2]];
        }
            break;
        case 4:
        {
            _time1Label.text = @"";
            _time2Label.text = [self timeStrFromReading:[_readings objectAtIndex:0]];
            _time3Label.text = [self timeStrFromReading:[_readings objectAtIndex:1]];
            _time4Label.text = [self timeStrFromReading:[_readings objectAtIndex:2]];
            _time5Label.text = [self timeStrFromReading:[_readings objectAtIndex:3]];
        }
            break;
        case 5:
        {
            _time1Label.text = [self timeStrFromReading:[_readings objectAtIndex:0]];
            _time2Label.text = [self timeStrFromReading:[_readings objectAtIndex:1]];
            _time3Label.text = [self timeStrFromReading:[_readings objectAtIndex:2]];
            _time4Label.text = [self timeStrFromReading:[_readings objectAtIndex:3]];
            _time5Label.text = [self timeStrFromReading:[_readings objectAtIndex:4]];
        }
            break;
        default:
        {
            _time1Label.text = [self timeStrFromDate:_firstDate];
            _time2Label.text = [self timeStrFromDate:[_firstDate initWithTimeInterval:_timeGap/4 sinceDate:_firstDate]];
            _time3Label.text = [self timeStrFromDate:[_firstDate initWithTimeInterval:_timeGap/2 sinceDate:_firstDate]];
            _time4Label.text = [self timeStrFromDate:[_firstDate initWithTimeInterval:_timeGap*3/4 sinceDate:_firstDate]];
            _time5Label.text = [self timeStrFromDate:_lastDate];
        }
            break;
    }
}

-(void)showPlot:(float)temp x:(NSUInteger)x
{
    NSUInteger y_gap = _graphRect.size.height/7;
    NSUInteger y = _graphRect.origin.y + (temp - 35.0f)*y_gap;
    CGRect frame = CGRectMake(x, y, TEM_W_H, TEM_W_H);
    GraphView* temView = [[GraphView alloc]initWithFrame:frame];
    [self.view addSubview:temView];
}
-(void)processTemperatureLabel
{
    switch ([_readings count]) {
        case 1:
        {
            TemperatureReading* read = [_readings objectAtIndex:0];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width/2];
        }
            break;
        case 2:
        {
            TemperatureReading* read = [_readings objectAtIndex:0];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x];
            
            read = [_readings objectAtIndex:1];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width];
        }
            break;
        case 3:
        {
            TemperatureReading* read = [_readings objectAtIndex:0];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x];
            
            read = [_readings objectAtIndex:1];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width/2];
            
            read = [_readings objectAtIndex:2];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width];
        }
            break;
        case 4:
        {
            TemperatureReading* read = [_readings objectAtIndex:0];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x+ _graphRect.size.width/4];
            
            read = [_readings objectAtIndex:1];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width/2];
            
            read = [_readings objectAtIndex:2];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width*3/4];
            
            read = [_readings objectAtIndex:3];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width];
            
        }
            break;
        case 5:
        {
            TemperatureReading* read = [_readings objectAtIndex:0];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x];
            
            read = [_readings objectAtIndex:1];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x+ _graphRect.size.width/4];
            
            read = [_readings objectAtIndex:2];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width/2];
            
            read = [_readings objectAtIndex:3];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width*3/4];
            
            read = [_readings objectAtIndex:4];
            [self showPlot:[read.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width];
            
        }
            break;
        default:
        {
            for (TemperatureReading* reading in _readings) {
                if (reading == [_readings firstObject]) {
                    [self showPlot:[reading.value floatValue]  x:_graphRect.origin.x];
                }else if(reading == [_readings lastObject]) {
                    [self showPlot:[reading.value floatValue]  x:_graphRect.origin.x + _graphRect.size.width];
                }else{
                    
                    NSTimeInterval Gap = [reading.date timeIntervalSinceDate:_firstDate];
                    NSUInteger x = _graphRect.origin.x + _graphRect.size.width*(Gap/_timeGap);
                    
                    [self showPlot:[reading.value floatValue]  x:x];
                }
            }
        }
            break;
    }
}
-(void)backButtonPressed
{
    GraphViewController* grahViewController = [[GraphViewController alloc]init];
    [self.navigationController pushViewController:grahViewController animated:YES];
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

-(CGFloat)hightestTempInArray:(NSArray*)arry
{
    CGFloat tem = 0;
    
    TemperatureReading* firstReading = [arry objectAtIndex:0];
    tem = [firstReading.value floatValue];
    
    for (TemperatureReading* obj in arry) {
        if ([obj.value floatValue] > tem) {
            tem = [obj.value floatValue];
        }
    }
    return tem;
}

-(void)firstAndLastDate:(NSArray*)arry
{
    TemperatureReading* firstReading = [arry objectAtIndex:0];
    _firstDate = firstReading.date;
    _lastDate = firstReading.date;
    
    for (TemperatureReading* obj in arry) {
        _firstDate = [obj.date earlierDate:_firstDate];
        _lastDate = [obj.date laterDate:_lastDate];
    }
    
    _timeGap = [_lastDate timeIntervalSinceDate:_firstDate];
    
}
@end