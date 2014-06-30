//
//  NSDate+JBCommon.m
//  nRF Temp
//
//  Created by Monster on 14-5-19.
//
//

#import "NSDate+JBCommon.h"

@implementation NSDate (JBCommon)


+(NSMutableArray*)currentMonthAllDay:(NSDate*)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    
    NSMutableArray* arry = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    for (NSUInteger num = 1; num <= range.length; num ++) {
        NSDateComponents *fromTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit ) fromDate:date];
        NSDateComponents *toTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit ) fromDate:[NSDate date]];
        [toTimeComponents setYear:[fromTimeComponents year]];
        [toTimeComponents setMonth:[fromTimeComponents month]];
        [toTimeComponents setDay:num];
        [toTimeComponents setHour:0];
        [toTimeComponents setMinute:0];
        [toTimeComponents setSecond:0];
        NSDate* dat = [cal dateFromComponents:toTimeComponents];
        [arry addObject:dat];
    }
    return arry;
}


+(NSDate*)currentMonthFirstDay:(NSDate*)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    
    
    NSDateComponents *fromTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit ) fromDate:date];
    NSDateComponents *toTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit ) fromDate:[NSDate date]];
    [toTimeComponents setYear:[fromTimeComponents year]];
    [toTimeComponents setMonth:[fromTimeComponents month]];
    [toTimeComponents setDay:35];
    [toTimeComponents setHour:0];
    [toTimeComponents setMinute:0];
    [toTimeComponents setSecond:0];
    return [cal dateFromComponents:toTimeComponents];
}

+(NSDate*)currentDayStartTime:(NSDate*)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    
    
    NSDateComponents *fromTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:date];
    NSDateComponents *toTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[NSDate date]];
    [toTimeComponents setYear:[fromTimeComponents year]];
    [toTimeComponents setMonth:[fromTimeComponents month]];
    [toTimeComponents setDay:[fromTimeComponents day]];
    [toTimeComponents setHour:0];
    [toTimeComponents setMinute:0];
    [toTimeComponents setSecond:0];
    return [cal dateFromComponents:toTimeComponents];
}

+(NSDate*)currentDayEndTime:(NSDate*)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    
    
    NSDateComponents *fromTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:date];
    NSDateComponents *toTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[NSDate date]];
    [toTimeComponents setYear:[fromTimeComponents year]];
    [toTimeComponents setMonth:[fromTimeComponents month]];
    [toTimeComponents setDay:[fromTimeComponents day]];
    [toTimeComponents setHour:23];
    [toTimeComponents setMinute:59];
    [toTimeComponents setSecond:59];
    return [cal dateFromComponents:toTimeComponents];
}

+(NSDate*)dateWithYear:(NSUInteger)year Month:(NSUInteger)month
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *toTimeComponents = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit ) fromDate:[NSDate date]];
    [toTimeComponents setYear:year];
    [toTimeComponents setMonth:month];
    [toTimeComponents setDay:1];
    [toTimeComponents setHour:0];
    [toTimeComponents setMinute:0];
    [toTimeComponents setSecond:0];
    return [cal dateFromComponents:toTimeComponents];
}

/**********************************************************
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 ***********************************************************/
- (NSDateComponents *)componentsOfDay
{
    static NSDateComponents *dateComponents = nil;
    static NSDate *previousDate = nil;
    static NSCalendar *greCalendar;
    if (!greCalendar) {
        greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    
    if (!previousDate || ![previousDate isEqualToDate:self]) {
        previousDate = self;
        dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    }
    return dateComponents;
}

/****************************************************
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 ****************************************************/
- (NSUInteger)year
{
    return [self componentsOfDay].year;
}

/****************************************************
 *@Description:获得NSDate对应的月份
 *@Params:nil
 *@Return:NSDate对应的月份
 ****************************************************/
- (NSUInteger)month
{
    return [self componentsOfDay].month;
}


/****************************************************
 *@Description:获得NSDate对应的日期
 *@Params:nil
 *@Return:NSDate对应的日期
 ****************************************************/
- (NSUInteger)day
{
    return [self componentsOfDay].day;
}


/****************************************************
 *@Description:获得NSDate对应的小时数
 *@Params:nil
 *@Return:NSDate对应的小时数
 ****************************************************/
- (NSUInteger)hour
{
    return [self componentsOfDay].hour;
}


/****************************************************
 *@Description:获得NSDate对应的分钟数
 *@Params:nil
 *@Return:NSDate对应的分钟数
 ****************************************************/
- (NSUInteger)minute
{
    return [self componentsOfDay].minute;
}


/****************************************************
 *@Description:获得NSDate对应的秒数
 *@Params:nil
 *@Return:NSDate对应的秒数
 ****************************************************/
- (NSUInteger)second
{
    return [self componentsOfDay].second;
}

/****************************************************
 *@Description:获得NSDate对应的星期
 *@Params:nil
 *@Return:NSDate对应的星期
 ****************************************************/
- (NSUInteger)weekday
{
    return [self componentsOfDay].weekday;
}

@end
