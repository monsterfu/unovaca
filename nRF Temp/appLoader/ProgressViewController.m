//
//  ProgressViewController.m
//  nRF Loader
//
//  Created by Ole Morten on 11/6/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "ProgressViewController.h"

#import "AppInfoCell.h"
#import "DeviceInformationCell.h"

@interface ProgressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property BOOL isTransferring;
@end

@implementation ProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    UIBarButtonItem* _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.dfuController.delegate = self;
    
    self.appNameLabel.text = self.dfuController.appName;
    self.appSizeLabel.text = [NSString stringWithFormat:@"%d bytes", self.dfuController.appSize];
    
    self.targetNameLabel.text = self.dfuController.targetName;
    self.targetStatusLabel.text = @"-";
    
    self.uploadButton.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.dfuController cancelTransfer];
    self.isTransferring = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadButtonPressed:(id)sender
{
    if (!self.isTransferring)
    {
        self.isTransferring = YES;
        [self.dfuController startTransfer];
        [self.uploadButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    }
    else
    {
        self.isTransferring = NO;
        [self.dfuController cancelTransfer];
        [self.uploadButton setTitle:NSLocalizedString(@"更新", nil) forState:UIControlStateNormal];
    }
}

- (void) didUpdateProgress:(float) progress
{
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f %%", progress*100];
    [self.progressView setProgress:progress animated:YES];
}

- (void) didFinishTransfer
{
    NSString *message = NSLocalizedString(@"The upload completed successfully", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Finished upload!",nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) didCancelTransfer
{
    NSString *message = NSLocalizedString(@"The upload was cancelled",nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Canceled upload",nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didDisconnect:(NSError *)error
{
    NSString *message = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"The connection was lost, with error description", nil), error.description];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection lost",nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didChangeState:(DFUControllerState)state
{
    if (state == IDLE)
    {
        self.uploadButton.enabled = YES;
    }
    self.targetStatusLabel.text = [self.dfuController stringFromState:state];
}
@end
