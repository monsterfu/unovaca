//
//  TargetViewController.h
//  nRF Loader
//
//  Created by Ole Morten on 10/8/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFUController.h"
#import "UIImage+scaleToSize.h"

@interface AppSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *binariesTableView;

@property DFUController *dfuController;

@end
