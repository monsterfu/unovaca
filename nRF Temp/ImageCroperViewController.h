//
//  ImageCroperViewController.h
//  Unova Thermometer
//
//  Created by 符鑫 on 14-7-16.
//
//

#import <UIKit/UIKit.h>
#import "BJImageCropper.h"


@protocol ImageCroperViewControllerDelegate <NSObject>

-(void)useEditImage:(UIImage*)image;

@end


@interface ImageCroperViewController : UIViewController{
    BJImageCropper *imageCropper;
    
    UILabel *boundsText;
}

@property(nonatomic, assign)id<ImageCroperViewControllerDelegate>delegate;
@property (nonatomic, retain)UIImage* editImage;
@property (weak, nonatomic) IBOutlet UILabel *bounsTest;
@property (nonatomic, strong) BJImageCropper *imageCropper;

@property (nonatomic, strong) UIImageView *preview;
@end
