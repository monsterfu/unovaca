//
//  IVMallTools.m
//  IVMall
//
//  Created by fangfang on 13-11-6.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import "IVMallTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "Toast+UIView.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation IVMallTools

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    //retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        //Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                //Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String: temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    //Get NSString from C String
                    address =[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    //Free memory
    freeifaddrs(interfaces);
    NSLog(@"addrees----%@",address);
    return address;
}

//程序中使用的，将日期显示成  2011年4月4日 星期一
+ (NSString *) Date2Str1:(NSDate *)indate{
    
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
	dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

//程序中使用的，提交日期的格式
+ (NSString *) Date2Str2:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyyMMdd";
	NSString *tempstr = [[dateFormatter stringFromDate:indate]copy];
	return tempstr;
}

//程序中使用的，提交日期的格式
+ (NSString *) Date2Str3:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

+ (NSString *)SystemDate2Str{
    NSDate *  indate=[NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

+ (NSString *)SystemDateTime2Str{
    NSDate *  indate=[NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"YYYY-MM-dd HH-mm-ss";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}


//提示窗口
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
												   delegate:nil cancelButtonTitle:NSLocalizedString(@"close",nil) otherButtonTitles:nil];
	[alert show];
}
+ (void)releaseObject:(NSObject*)object{
    if (object!=nil) {
        object=nil;
    }
}
//获得日期的具体信息，本程序是为获得星期，注意！返回星期是 int 型，但是和中国传统星期有差异
+ (NSDateComponents *) DateInfo:(NSDate *)indate{
    
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
	NSDateComponents *comps = [calendar components:unitFlags fromDate:indate];
	
	return comps;
}

+(UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)itemSize{
    
    UIImage *i;
    //    CGSize itemSize=CGSizeMake(30, 30);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect=CGRectMake(0, 0, itemSize.width, itemSize.height);
    [img drawInRect:imageRect];
    i=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}


+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];    
    return result;
}
//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}

+ (int)judgeDate:(NSString*)onday withday:(NSString*)withday{
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setDateFormat:@"yy/MM/dd"];
    NSDate *day1 = [dateFromatter dateFromString:onday];
    NSDate *day2 = [dateFromatter dateFromString:withday];
    
    NSComparisonResult result = [day1 compare:day2];
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}
//zjj
+ (NSDate *)dateFromString:(NSString *)string
{
    NSString* temp = @"T";
    NSRange rang = [string rangeOfString:temp];
    NSString* dateString = [string stringByReplacingCharactersInRange:rang withString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:sszzzz"];
    NSDate * date= [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)Date2Str4:(NSDate *)indate{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy.MM.dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

+ (NSString *)Date2Str6:(NSDate *)indate{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

+ (NSString *)Date2Str5:(NSDate *)indate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"HH:mm";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}
+(NSString*)changeImageURL:(NSString*)imageURL
{
//    
//    NSString* temp = [imageURL componentsSeparatedByString:@"/"].lastObject;
//    NSString* temp1 = [temp stringByReplacingOccurrencesOfString:@"jpg" withString:@"png"];
    NSString* temp2 = [NSString stringWithFormat:@"http://static.ivmall.com/images/szimg/%@.png",imageURL];
    NSLog(@"temp2 = %@",temp2);
    return temp2;
}
//zjj
+ (BOOL) isEmpty:(NSString *)nsstring{
    if(nsstring){
        if(nsstring.length>0){
            if(![nsstring isEqualToString:@"null"]){
                return false;
            }
        }
    }
    return true;
}
+ (int)pureInt:(NSString *)string{
    return [string intValue];
}

+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
/*
+(void)showErrormsg:(int)type msg:(NSString*)msg{
    NSString* message=@"";
    switch (type) {
        case 999:
            message=@"出了些小问题，请联系我们客服！";
            break;
        case 400:
            message=@"缺少参数，请检查参数是否填写完全！";
            break;
        case 101:
            message=@"您已是我们注册用户，可以直接登录使用！";
            break;
        case 102:
            message=@"您还未注册我们用户，请注册后登录！";
            break;
        case 103:
            message=@"手机号码或密码有误，请检查！";
            break;
        case 104:
            message=@"您需要重新登录！";
            break;
        case 105:
            message=@"您需要重新登录！";
            break;
        case 106:
            message=@"您需要登录后，才能使用此功能！";
            break;
        case 107:
            message=@"您的余额不足，请充值！";
            break;
        case 108:
            message=@"注册失败！";
            break;
        case 109:
            message=@"验证码错误！";
            break;
        case 110:
            message=@"手机号码错误！";
            break;
        case 111:
            message=@"密码不符合规则！";
            break;
        case 112:
            message=@"邮箱错误！";
            break;
        case 201:
            message=@"此频道已删除，请刷新频道后继续使用！";
            break;
        case 202:
            message=@"此产品已经下架！";
            break;
        case 203:
            message=@"此视频已经下架！";
            break;
        case 204:
            message=@"您还未购买此产品！";
            break;
        case 205:
            message=@"记录已存在！";
            break;
        case 206:
            message=@"您的卡号不存在！";
            break;
        case 207:
            message=@"JSON语法错误！";
            break;
        case 208:
            message=@"点数未定义rateDetailPointNotDefinde！";
            break;
        case 209:
            message=@"设备不存在！";
            break;
        case 210:
            message=@"验证码已过期！";
            break;
        case 212:
            message=@"该充值卡已充值过！";
            break;
        case 213:
            message=@"充值卡已过期！";
            break;
        case 307:
            message=@"验证码不正确！";
            break;
        case 0:
            message=msg;
            break;
            
        default:
            message=@"系统异常，请稍后再试！";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
*/

+ (void)showErrorMsg:(UIView*)view type:(int)type msg:(NSString *)msg{
    
    
    switch (type) {
        case 999://	未知错误
            [view makeToast:@"出了些小问题，请联系我们客服！"
                        duration:2.0
                        position:@"center"];
            break;
        case 400://	缺少参数
            [view makeToast:@"缺少参数，请检查参数是否填写完全！"
                   duration:2.0
                   position:@"center"];
            break;
        case 101://	用户已存在
            [view makeToast:@"您已是我们注册用户，可以直接登录使用！"
                   duration:2.0
                   position:@"center"];
                        break;
        case 102://	用户未存在
            [view makeToast:@"您还未注册我们用户，请注册后登录！"
                   duration:2.0
                   position:@"center"];
            break;
        case 103://	用户名/密码错误
            [view makeToast:@"手机号码或密码有误，请检查！"
                   duration:2.0
                   position:@"center"];
            break;
        case 104://	token不存在
            [view makeToast:@"您需要重新登录！"
                   duration:2.0
                   position:@"center"];
            break;
        case 105://	登录超时
            [view makeToast:@"您需要重新登录！"
                   duration:2.0
                   position:@"center"];
            break;
        case 106://	用户未登录
            [view makeToast:@"您需要登录后，才能使用此功能！"
                   duration:2.0
                   position:@"center"];
            break;
        case 107://	账户余额不足
            [view makeToast:@"您的余额不足，请充值！"
                   duration:2.0
                   position:@"center"];
            break;
        case 108:
            [view makeToast:@"注册失败！"
                   duration:2.0
                   position:@"center"];
            break;
        case 109:
            [view makeToast:@"验证码错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 110:
            [view makeToast:@"手机号码错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 111:
            [view makeToast:@"密码不符合规则！"
                   duration:2.0
                   position:@"center"];
            break;
        case 112:
            [view makeToast:@"邮箱错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 201://	该频道不存在
            [view makeToast:@"此频道已删除，请刷新频道后继续使用！"
                   duration:2.0
                   position:@"center"];
            break;
        case 202://	该产品不存在
            [view makeToast:@"此产品已经下架！"
                   duration:2.0
                   position:@"center"];
            break;
        case 203://	该视频不存在
            [view makeToast:@"此视频已经下架！"
                   duration:2.0
                   position:@"center"];
            break;
        case 204://	未购买该产品
            [view makeToast:@"您还未购买此产品！"
                   duration:2.0
                   position:@"center"];
            break;
        case 205:
            [view makeToast:@"记录已存在！"
                   duration:2.0
                   position:@"center"];
            break;
        case 206:
            [view makeToast:@"密码不存在！"
                   duration:2.0
                   position:@"center"];
            break;
        case 207:
            [view makeToast:@"JSON语法错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 208:
            [view makeToast:@"点数未定义rateDetailPointNotDefinde！"
                   duration:2.0
                   position:@"center"];
            break;
        case 209:
            [view makeToast:@"设备不存在！"
                   duration:2.0
                   position:@"center"];
            break;
        case 210:
            [view makeToast:@"验证码已过期！"
                   duration:2.0
                   position:@"center"];
            break;
        case 212://xiugai zjj
            [view makeToast:@"该充值卡已充值过！"
                   duration:2.0
                   position:@"center"];
            break;
        case 213://xiuga zjj
            [view makeToast:@"充值卡已过期！"
                   duration:2.0
                   position:@"center"];
            break;
        case 307:
            [view makeToast:@"验证码不正确！"
                   duration:2.0
                   position:@"center"];
            break;
        case 0:
            [view makeToast:msg
                   duration:2.0
                   position:@"center"];
            break;
        default:
            [view makeToast:@"系统异常，请稍后再试！"
                   duration:2.0
                   position:@"center"];
            break;
    }
}

//+(void)showMsgHUD:(int)type msg:(NSString*)msg{
//    switch (type) {
//        case 0:
//            [ProgressHUD dismiss];
//            break;
//        case 1:
//            [ProgressHUD show:msg];
//            break;
//        case 2:
//            [ProgressHUD showError:msg];
//            break;
//        case 3:
//            [ProgressHUD showSuccess:msg];
//            break;
//        default:
//            
//            break;
//    }
//}

#pragma mark - 判断密码强度函数

//判断是否包含

+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password{
    
    NSRange range;
    
    BOOL result =NO;
    
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound){
            result =YES;
        }
    }
    
    return result;
    
}

//条件

+ (int) judgePasswordStrength:(NSString*) _password{
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    
    int intResult=0;
    
    for (int j=0; j<[resultArray count]; j++){
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"]){
            intResult++;
        }
    }
    
    int resultInt=0;
    
    if (intResult <2){
        resultInt = 0;
    }else if (intResult == 2&&[_password length]>=6){
        resultInt = 1;
    }else if (intResult > 2&&[_password length]>=6){
        resultInt = 2;
    }
    
    return resultInt;
}

+(BOOL)determineCellPhoneNumber:(NSString*)str{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(16[0-9])|(18[0,1,2,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+(void)noNetwork:(UIViewController*)viewController{
    if ([self isEnableWIFI]==0) {
        [IVMallTools showErrorMsg:nil  type:0 msg:@"您当前网络未连接连接!"];
    }
}

+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+(NSString*)MD5:(NSMutableString*)str{
    
    const char *concat_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash =[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

+(NSString *)removeUnescapedCharacter:(NSString *)inputStr
{
    
//    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
//    
//    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];
//    
//    if (range.location != NSNotFound)
//    {
//        
//        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
//        
//        while (range.location != NSNotFound)
//        {
//            
//            [mutable deleteCharactersInRange:range];
//            
//            range = [mutable rangeOfCharacterFromSet:controlChars];
//            
//        }
//        
//        return mutable;
//        
//    }
    
    return inputStr;
}



+(void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString*)key {
    if (key == nil) {
        return NO;
    }
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image = nil;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        NSLog(@"未从本地获得图片");
    }
    return image;
}





@end
