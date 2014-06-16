//
//  PersonDetailSetViewController.h
//  nRF Temp
//
//  Created by Monster on 14-4-4.
//
//

#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "PersonViewController.h"

@interface PersonDetailSetViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSUInteger _selectItem;
    UIBarButtonItem* _saveButton;
    UIBarButtonItem* _cancelButton;
    UITextField* _textfieldLabel;
    NSDate* _birthDate;
    
    NSArray* _titleArray;
    
    NSArray* _sexArray;
    NSArray* _bloodArray;
    
    NSUInteger _selectTableCellIndex;
}
@property(nonatomic,retain)PersonDetailInfo* detailInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIPickerView * pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)buttonTouched:(UIButton *)sender;
@end
