//
//  GJCFDateUitil.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-22.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import "GJCFDateUitil.h"
#import "GJCFUitils.h"

@implementation GJCFDateUitil

+ (NSCalendar *)sharedCalendar
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    [currentCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    [currentCalendar setFirstWeekday:2];
    return currentCalendar;
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *_gjcfDateFormatter = nil;
    static dispatch_once_t onceToken;
    
    GJCFDispatchOnce(&onceToken, ^{
        
        if (!_gjcfDateFormatter) {
            _gjcfDateFormatter = [[NSDateFormatter alloc]init];
         }
    });
    return _gjcfDateFormatter;
}

+ (NSString *)detailTimeAgoString:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    long long timeNow = [date timeIntervalSince1970];
    NSCalendar * calendar=[GJCFDateUitil sharedCalendar];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year=(int)[component year];
    int month=(int)[component month];
    int day=(int)[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=(int)[component year];
    
    NSString*string=nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    
    return string;
}

+ (NSString *)detailTimeAgoStringByInterval:(long long)timeInterval
{
    return [GJCFDateUitil detailTimeAgoString:GJCFDateFromTimeInterval(timeInterval)];
}

+ (NSUInteger)daysAgoFromNow:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

+ (NSUInteger)daysAgoAgainstMidnight:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSDateFormatter *mdf = [[self class] sharedDateFormatter];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:date]];
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

+ (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag withDate:(NSDate *)date {
    
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    NSUInteger daysAgo = (flag) ? [GJCFDateUitil daysAgoAgainstMidnight:date] : [GJCFDateUitil daysAgoFromNow:date];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = @"今天";
            break;
        case 1:
            text = @"昨天";
            break;
        default:
            text = [NSString stringWithFormat:@"%ld天前", (long)daysAgo];
    }
    return text;
}

+ (NSString *)stringDaysAgo:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    return [GJCFDateUitil stringDaysAgoAgainstMidnight:YES withDate:date];
}

/*
 * iOS中规定的就是周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7，
 * 无法通过某个设置改变这个事实的，只能在使用的时候注意一下这个规则了。
 */
+ (NSUInteger)weekDay:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSDateComponents *weekdayComponents = [[[self class] sharedCalendar] components:(NSCalendarUnitWeekday) fromDate:date];
    //我们的习惯是周一为第一天，那么我们改一下就OK了
    NSUInteger wDay = [weekdayComponents weekday];
    //将第一天设为周日
    if (wDay == 1) {
        wDay = 7;
    }else{
        wDay = wDay - 1;
    }
    return wDay;
}

+ (NSString *)weekDayString:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    NSDictionary *weekNameDict = @{
                                   @(1):@"一",
                                   @(2):@"二",
                                   @(3):@"三",
                                   @(4):@"四",
                                   @(5):@"五",
                                   @(6):@"六",
                                   @(7):@"日",
                                   };
    NSString *weekName = [weekNameDict objectForKey:@(GJCFDateGetWeekDay(date))];
    return [NSString stringWithFormat:@"星期%@",weekName];
}

+ (NSString *)weekNumberString:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    return [NSString stringWithFormat:@"第%lu周",(unsigned long)GJCFDateGetWeekNum(date)];
}

+ (NSUInteger)weekNumber:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitWeekOfYear) fromDate:date];
    return [dateComponents weekOfYear];
}

+ (NSUInteger)hour:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
    return [dateComponents hour];
}

+ (NSUInteger)minute:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
    return [dateComponents minute];
}

+ (NSUInteger)year:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
    return [dateComponents year];
}

+ (NSUInteger)month:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
    return [dateComponents month];
}

+ (NSInteger)day:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return NSIntegerMax;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
    return [dateComponents day];
}

+ (NSDate *)dateFromTimeInterval:(long long)timeInterval
{
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSDate *)dateFromString:(NSString *)string
{
    if (GJCFStringIsNull(string)) {
        return nil;
    }
    return [GJCFDateUitil dateFromString:string withFormat:kNSDateHelperFormatSQLDate];
}

+ (NSDate *)dateTimeFromString:(NSString *)string
{
    if (GJCFStringIsNull(string)) {
        return nil;
    }
    return [GJCFDateUitil dateFromString:string withFormat:kNSDateHelperFormatSQLDateWithTime];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    if (GJCFCheckKeyValueHasNull(string, format)) {
        return nil;
    }
    NSDateFormatter *formatter = [self sharedDateFormatter];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string
{
    if (GJCFCheckKeyValueHasNull(string, date)) {
        return nil;
    }
    [[[self class] sharedDateFormatter] setDateFormat:string];
    NSString *timestamp_str = [[[self class] sharedDateFormatter] stringFromDate:date];
    return timestamp_str;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    return [GJCFDateUitil stringFromDate:date withFormat:kNSDateHelperFormatSQLDateWithTime];
}

+ (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle withDate:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    [[[self class] sharedDateFormatter] setDateStyle:dateStyle];
    [[[self class] sharedDateFormatter] setTimeStyle:timeStyle];
    NSString *outputString = [[[self class] sharedDateFormatter] stringFromDate:date];
    return outputString;
}

+ (NSDate *)beginningOfWeek:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDate *beginningOfWeek = nil;
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginningOfWeek
                           interval:NULL forDate:date];
    if (ok) {
        return beginningOfWeek;
    }
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];

    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                               fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];

}

+ (NSDate *)beginningOfDay:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    // Get the weekday component of the current date
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                               fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfWeek:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];

    return endOfWeek;
}

+ (NSString *)dateFormatString
{
    return kNSDateHelperFormatSQLDate;
}

+ (NSString *)timeFormatString
{
    return kNSDateHelperFormatSQLTime;
}

+ (NSString *)timestampFormatString
{
    return kNSDateHelperFormatSQLDateWithTime;
}

+ (NSString *)dbFormatString
{
    return kNSDateHelperFormatSQLDateWithTime;
}

+ (NSString *)birthdayToAge:(NSDate *)date
{
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
    
    if ([components year] > 0) {
        
        return [NSString stringWithFormat:@"%d岁",(int)[components year]];

    }else if([components month] > 0) {
        
        return [NSString stringWithFormat:@"%d个月%d天",(int)[components month],(int)[components day]];
        
    }else{
        
        return [NSString stringWithFormat:@"%d天",(int)[components day]];

    }
}

+ (NSString *)birthdayToAgeByTimeInterval:(NSTimeInterval)date
{
    return [GJCFDateUitil birthdayToAge:GJCFDateFromTimeInterval(date)];
}

+ (NSString *)dateToConstellation:(NSDate *)date
{
    NSInteger day = [GJCFDateUitil day:date];
    NSInteger month = [GJCFDateUitil month:date];
    if (day == NSNotFound || month == NSNotFound) {
        return nil;
    }
    NSString *res = @"";
    switch (month) {
        case 1: {
            if (day <= 19) {
                res = @"摩羯座";
            } else {
                res = @"水瓶座";
            }
            break;
        }
        case 2: {
            if (day <= 18) {
                res = @"水瓶座";
            } else {
                res = @"双鱼座";
            }
            break;
        }
        case 3: {
            if (day <= 20) {
                res = @"双鱼座";
            } else {
                res = @"白羊座";
            }
            break;
        }
        case 4: {
            if (day <= 19) {
                res = @"白羊座";
            } else {
                res = @"金牛座";
            }
            break;
        }
        case 5: {
            if (day <= 20) {
                res = @"金牛座";
            } else {
                res = @"双子座";
            }
            break;
        }
        case 6: {
            if (day <= 21) {
                res = @"双子座";
            } else {
                res = @"巨蟹座";
            }
            break;
        }
        case 7: {
            if (day <= 22) {
                res = @"巨蟹座";
            } else {
                res = @"狮子座";
            }
            break;
        }
        case 8: {
            if (day <= 22) {
                res = @"狮子座";
            } else {
                res = @"处女座";
            }
            break;
        }
        case 9: {
            if (day <= 22) {
                res = @"处女座";
            } else {
                res = @"天秤座";
            }
            break;
        }
        case 10: {
            if (day <= 23) {
                res = @"天秤座";
            } else {
                res = @"天蝎座";
            }
            break;
        }
        case 11: {
            if (day <= 22) {
                res = @"天蝎座";
            } else {
                res = @"射手座";
            }
            break;
        }
        case 12: {
            if (day <= 21) {
                res = @"射手座";
            } else {
                res = @"摩羯座";
            }
            break;
        }
        default:
            break;
    }
    return res;
}

+ (NSString *)dateToConstellationByTimeInterval:(NSTimeInterval)date
{
    return [GJCFDateUitil dateToConstellation:GJCFDateFromTimeInterval(date)];
}

@end
