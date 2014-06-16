//
//  NSDate+JBCommon.h
//  nRF Temp
//
//  Created by Monster on 14-5-19.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (JBCommon)

+(NSMutableArray*)currentMonthAllDay:(NSDate*)date;

+(NSDate*)currentDayStartTime:(NSDate*)date;
+(NSDate*)currentDayEndTime:(NSDate*)date;
/****************************************************
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 ****************************************************/
+(NSDate*)currentMonthFirstDay:(NSDate*)date;
+(NSDate*)dateWithYear:(NSUInteger)year Month:(NSUInteger)month;
/****************************************************
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 ****************************************************/
- (NSUInteger)year;

/****************************************************
 *@Description:获得NSDate对应的月份
 *@Params:nil
 *@Return:NSDate对应的月份
 ****************************************************/
- (NSUInteger)month;


/****************************************************
 *@Description:获得NSDate对应的日期
 *@Params:nil
 *@Return:NSDate对应的日期
 ****************************************************/
- (NSUInteger)day;


/****************************************************
 *@Description:获得NSDate对应的小时数
 *@Params:nil
 *@Return:NSDate对应的小时数
 ****************************************************/
- (NSUInteger)hour;


/****************************************************
 *@Description:获得NSDate对应的分钟数
 *@Params:nil
 *@Return:NSDate对应的分钟数
 ****************************************************/
- (NSUInteger)minute;


/****************************************************
 *@Description:获得NSDate对应的秒数
 *@Params:nil
 *@Return:NSDate对应的秒数
 ****************************************************/
- (NSUInteger)second;

/****************************************************
 *@Description:获得NSDate对应的星期
 *@Params:nil
 *@Return:NSDate对应的星期
 ****************************************************/
- (NSUInteger)weekday;

@end
