//
//  PersonViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-3.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "PersonDetailInfo.h"
#import "PersonPhotoCell.h"
#import "PersonDetailSetViewController.h"

enum PersonInfoEnum {
    PersonInfoHeadIcon = 0,
    PersonInfoNickName = 1,
    PersonInfoBirthday = 2,
    PersonInfoSex      = 3,
    PersonInfoHigh     = 4,
    PersonInfoHeight   = 5,
    PersonInfoBlood    = 6,
    PersonInfoNumMax   = 7
    };

@interface PersonViewController : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel* _Label;
    NSMutableArray* _mutableArray;
    UIActionSheet* _actionSheetView;
    UIImagePickerController* _imagePickerController;
    UIPickerView* _pickerView;
    UIBarButtonItem* _saveButton;
    UIBarButtonItem* _cancelButton;
    
    UIImage* _headIcon;
    
    PersonPhotoCell * _headCell;
    UITableViewCell * _otherCell;
    
    NSArray* _sexArray;
    NSArray* _bloodArray;
    
    
}
@property(nonatomic,retain)PersonDetailInfo* detailInfo;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,assign)BOOL isNew;
@end
