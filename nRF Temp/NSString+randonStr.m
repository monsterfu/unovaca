//
//  NSString+randonStr.m
//  nRF Temp
//
//  Created by Monster on 14-6-26.
//
//

#import "NSString+randonStr.h"
#import "PublicDefine.h"

@implementation NSString (randonStr)

+(NSString*)randomStr
{
    u_int32_t i = arc4random();
    NSString* randStr = [NSString stringWithFormat:@"%d",i];
    randStr = [randStr stringByReplacingOccurrencesOfString:@"-" withString:@"1"];
    randStr = [randStr substringToIndex:6];
    return randStr;
}
+(NSString*)fobKey
{
    return [NSString stringWithFormat:@"%@%@",[USER_DEFAULT objectForKey:KEY_SELECED_FOB],[USER_DEFAULT objectForKey:KEY_PERSONID]];
}
@end
