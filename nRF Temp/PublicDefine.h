//
//  PublicDefine.h
//  nRF Temp
//
//  Created by Monster on 14-4-3.
//
//

#ifndef nRF_Temp_PublicDefine_h
#define nRF_Temp_PublicDefine_h

#import "XMLReader.h"
#import "SBJson/SBJson.h"
#import "NSDate+JBCommon.h"
#import "UIImage+scaleToSize.h"
#import "NSString+randonStr.h"

#define VISION_NO    @"1.1.0"


#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define APP_BACKGROUND_COLOR  [UIColor colorWithRed:0 green:222/255.0 blue:111/255.0 alpha:1.0]

#define KEY_HEADICON_STR    @"key_headicon_str"
#define KEY_NICKNAME_STR    @"key_nickname_str"
#define KEY_BLOOD_STR       @"key_blood_str"
#define KEY_SEX_STR         @"key_sex_str"
#define KEY_HIGH_STR        @"key_high_str"
#define KEY_HEIGHT_STR      @"key_height_str"
#define KEY_BIRTH_STR       @"key_birth_str"
#define KEY_PERSONDETAIL_SELECT_STR     @"key_persondetail_select_str"

//main
#define KEY_USERNAME       @"key_username"
#define KEY_PERSONID       @"key_personid"
#define KEY_FOBNAME       @"key_fobname"
#define KEY_FOBUUID         @"key_fobuuid"

#define KEY_SELECED_FOB        @"key_selected_fob"
#define KEY_BACKGROUND_OPEN     @"key_background_open"
//setting

#define KEY_GAPTIMER_STR   @"key_gaptimer_str"   //时间间隔
#define KEY_LOWEST_STR     @"key_lowest_str"     //最低温度
#define KEY_MOST_STR       @"key_most_str"       //最高温度

#define KEY_WARNING_OPEN   @"key_warning_open"   //报警开关
//弧度、角度转换
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

//主页
#define KEY_PERSON_SELECTED @"key_person_selected"

//温度历史 时间选择

#define KEY_SELECTED_YEAR   @"key_selected_year"
#define KEY_SELECTED_MONTH  @"key_selected_month"

//通知
#define NSNotificationCenter_EventReminderChanged       @"NSNotificationCenter_EventReminderChanged"
#define NSNotificationCenter_PersonDetailChanged        @"NSNotificationCenter_PersonDetailChanged"
#endif
