//
//  IVMallTools.h
//  IVMall
//
//  Created by fangfang on 13-11-6.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVMallTools : NSObject

+ (NSString *)getIPAddress;
+ (NSString *)Date2Str1:(NSDate *)indate;
+ (NSString *)Date2Str2:(NSDate *)indate;
+ (NSString *)Date2Str3:(NSDate *)indate;
+ (NSString *)SystemDate2Str;
+ (NSString *)SystemDateTime2Str;
+ (void)MsgBox:(NSString *)msg;
+ (void)releaseObject:(NSObject*)object;
//+ (NSString *) md5:(NSString *)str;
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;
+ (NSDateComponents *)DateInfo:(NSDate *)indate;
+ (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)itemSize;
+ (void)OpenUrl:(NSString *)inUrl;

+ (BOOL)isEmpty:(NSString*)nsstring;
+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isPureFloat:(NSString *)string;
+ (int)pureInt:(NSString *)string;

+ (int)judgeDate:(NSString*)onday withday:(NSString*)withday;
//zjj
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)Date2Str4:(NSDate *)indate;
+ (NSString *)Date2Str5:(NSDate *)indate;
+ (NSString *)Date2Str6:(NSDate *)indate;
+(NSString*)changeImageURL:(NSString*)imageURL;
//zjj

//+(void)showErrormsg:(int)type msg:(NSString*)msg;

+ (void)showErrorMsg:(UIView*)view type:(int)type msg:(NSString*)msg;

//+ (void)showMsgHUD:(int)type msg:(NSString*)msg;


+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password;
+ (int) judgePasswordStrength:(NSString*) _password;

+(BOOL)determineCellPhoneNumber:(NSString*)str;//手机正则表达式

+(int) isEnableWIFI;//是否连接wifi
+(void)noNetwork:(UIViewController*)viewController;

+(NSString*)MD5:(NSMutableString*)str;

+(NSString *)removeUnescapedCharacter:(NSString *)inputStr;


+(void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key;
+ (BOOL)LocalHaveImage:(NSString*)key;
+ (UIImage*)GetImageFromLocal:(NSString*)key ;


@end
