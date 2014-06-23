//
//  GraphViewController.m
//  nRF Temp
//
//  Created by Ole Morten on 10/19/12.
//
//

#import "GraphViewController.h"

@interface GraphViewController ()
@property NSArray *records;
@property UISegmentedControl *timeframeControl;
@end

@implementation GraphViewController

@synthesize fob = _fob;

//
//- (void)viewDidLoad
//{
//    self.timeframeControl = [[UISegmentedControl alloc] initWithItems:@[@"Today", @"Week", @"Month", @"Custom"]];
////    for (NSUInteger i =0; i < 64; i++) {
////        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(i*5, 64, 5, 430)];
////        [img setImage:[UIImage imageNamed:@"color.png"]];
////        [self.view addSubview:img];
////        [self.view sendSubviewToBack:img];
////    }
//    [self.timeframeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
//    [self.timeframeControl setSelectedSegmentIndex:0];
//    [self.timeframeControl addTarget:self action:@selector(timeframeControlChanged) forControlEvents:UIControlEventValueChanged];
//    
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.timeframeControl];
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [self setToolbarItems:@[spaceItem, barItem, spaceItem] animated:YES];
//
//    if (![self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
//    {
//        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
//    }
//    else
//    {
//        self.navigationController.toolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
//        self.navigationController.toolbar.tintColor = [UIColor whiteColor];
//        self.navigationController.toolbar.translucent = NO;
//    }
//    
//    [super viewDidLoad];
//    
////    UIBarButtonItem* backButtom = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backhl.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
//////    [backButtom setImageInsets:UIEdgeInsetsMake(6, 0, 6, 10)];
////    self.navigationItem.leftBarButtonItem = backButtom;
//}
//
//-(void)backButtonPressed
//{
//    [self.navigationController popViewControllerAnimated:YES];
//
//}
//
//- (void) viewWillAppear:(BOOL)animated
//{
////    [self.navigationController setToolbarHidden:YES animated:animated];
//    
//    if (self.fob)
//    {
//        self.navigationItem.title = self.fob.location;
//    }
//}
//
//- (void) viewWillDisappear:(BOOL)animated
//{
////    [self.navigationController setToolbarHidden:YES animated:YES];
//}
//
//- (void) viewDidAppear:(BOOL)animated
//{
//    _fob.delegate = self;
//    [self initPlot];
//}
//
//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if ([self.graphView.subviews count] > 0)
//    {
//        [[self.graphView.subviews objectAtIndex:0] setFrame:self.graphView.bounds];
//        [self.graphView layoutSubviews];
//    }
//}
//
//- (void) setFob:(TemperatureFob *)newFob
//{
//    if (newFob != _fob)
//    {
//        _fob = newFob;
//        _records = [_fob lastReadings:1000];
//    }
//}
//
//- (void) timeframeControlChanged
//{
//    NSLog(@"Timeframe changed");
//    
//    }
//
//- (void) setTimeframe:(NSUInteger) minutes
//{
//    _records = [self.fob lastReadingsSince:minutes];
//    [self.temperaturePlot reloadData];
//    
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.graph.defaultPlotSpace;
//    plotSpace.globalYRange = nil;
//    [plotSpace scaleToFitPlots:@[self.temperaturePlot]];
//    
//    double startTime = [[NSDate dateWithTimeIntervalSinceNow:-(60.0*minutes)] timeIntervalSince1970];
//    // Make sure that we show a little more than the last item.
//    double length = 60.0*minutes * 1.02;
//    plotSpace.xRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromFloat(startTime) length:CPTDecimalFromFloat(length)];
//    
//    double maxValue = [[_records valueForKeyPath:@"@max.value"] doubleValue] + 2;
//    double minValue = [[_records valueForKeyPath:@"@min.value"] doubleValue] - 2;
//    
//    plotSpace.yRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromFloat(minValue) length:CPTDecimalFromDouble(maxValue - minValue)];
//    
//    // Avoid zooming further out.
//    plotSpace.globalYRange = plotSpace.yRange;
//}
//
//- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
//{
//    // Avoid zooming in closer than 6 hours on the X axis and 4 degrees on the Y axis
//    if (((coordinate == CPTCoordinateX) && (newRange.lengthDouble < 60.0*60.0*6.0)) ||
//        ((coordinate == CPTCoordinateY) && (newRange.lengthDouble < 4.0)))
//    {
//        NSLog(@"Don't want to zoom in to this level: %@", newRange);
//        return [space plotRangeForCoordinate:coordinate];
//    }
//    return newRange;
//}
//
//- (void) initPlot
//{
//    // Set up view. Make sure the plot will fith within the designated box.
//    self.graph = [[CPTXYGraph alloc] initWithFrame:self.graphView.bounds];
//
//    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:self.graphView.bounds];
//    self.hostView.hostedGraph = self.graph;
//
//    [self.graphView addSubview:self.hostView];
//    
//    // Set up the look of the plot. Want
//    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
//    // Make things see through.
//    self.graph.backgroundColor = nil;
//    self.graph.fill = nil;
//    self.graph.plotAreaFrame.fill = nil;
//    self.graph.plotAreaFrame.plotArea.fill = nil;
//
//    self.graph.plotAreaFrame.borderLineStyle = nil;
//    self.graph.plotAreaFrame.masksToBorder = NO;
//
//    self.graph.paddingBottom = 60.0;
//    self.graph.paddingLeft = 36.0;
//    self.graph.paddingRight = 5.0;
//    self.graph.paddingTop = 10.0;
//    
//    // Set up the plot, including the look of the plot itself.
//    self.temperaturePlot = [[CPTScatterPlot alloc] init];
//    self.temperaturePlot.dataLineStyle = nil;
//    
//    self.temperaturePlot.dataSource = self;
//    self.temperaturePlot.delegate = self;
//    
//    CPTMutableLineStyle *temperatureLineStyle = [[CPTMutableLineStyle alloc] init];
//    temperatureLineStyle.lineWidth = 1.0;
//    temperatureLineStyle.lineColor = [CPTColor blackColor];
//    
//    CPTPlotSymbol *temperatureSymbol = [CPTPlotSymbol ellipsePlotSymbol];
//    temperatureSymbol.lineStyle = temperatureLineStyle;
//    self.temperaturePlot.plotSymbol = temperatureSymbol;
//    
//    // Add plot.
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.graph.defaultPlotSpace;
//    plotSpace.delegate = self;
//    [self.graph addPlot:self.temperaturePlot toPlotSpace:plotSpace];
//    
//    // Show a day back per default.
//    [self setTimeframe:24*60];
//    
//    // Set up axis.
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graph.axisSet;
//    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
//    axisSet.xAxis.preferredNumberOfMajorTicks = 5;
//    axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
//
//    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
//    axisSet.yAxis.preferredNumberOfMajorTicks = 6;
//    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
//
//    // Set up labels.
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd/MM/yyyy\n\tHH:mm"];
//
//    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:formatter];
//    timeFormatter.referenceDate = [NSDate dateWithTimeIntervalSince1970:0];
//
//    axisSet.xAxis.labelFormatter = timeFormatter;
//    axisSet.xAxis.labelRotation = M_PI/4;
//    
//    CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
//    labelTextStyle.textAlignment = CPTTextAlignmentCenter;
//    labelTextStyle.color = [CPTColor blackColor];
//    labelTextStyle.fontSize = 10.0;
//    axisSet.xAxis.labelTextStyle = labelTextStyle;
//    axisSet.yAxis.labelTextStyle = labelTextStyle;
//
//    // Configure grid
//    CPTMutableLineStyle *gridLineStyle = [[CPTMutableLineStyle alloc] init];
//    gridLineStyle.lineColor = [CPTColor grayColor];
//    gridLineStyle.lineWidth = 0.5;
//    axisSet.xAxis.majorGridLineStyle = gridLineStyle;
//    axisSet.yAxis.majorGridLineStyle = gridLineStyle;
//}
//
//
//- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot
//{
//    return [_records count];
//}
//
//- (NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
//{
//    TemperatureReading *reading = [_records objectAtIndex:index];
//
//    if (fieldEnum == CPTScatterPlotFieldX)
//    {
//        return [NSNumber numberWithDouble:[reading.date timeIntervalSince1970]];
//    }
//    if (fieldEnum == CPTScatterPlotFieldY)
//    {
//        return reading.value;
//    }
//    return [NSNumber numberWithFloat:0.0];
//}
//-(void) recentUpdateData:(CGFloat)value
//{
//    
//}
//- (void) didUpdateData:(TemperatureFob *)fob
//{
//    if (self.fob == fob)
//    {
//        [[self.graph plotAtIndex:0] reloadData];
//    }
//}
@end
