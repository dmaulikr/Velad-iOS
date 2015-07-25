//
//  NSDate+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "NSDate+VLDAdditions.h"
#import "NSCalendar+VLDAdditions.h"

@implementation NSDate (VLDAdditions)

- (BOOL)vld_isToday {
    NSCalendar *calendar = [NSCalendar vld_preferredCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:components];
    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                             fromDate:self];
    NSDate *selfDate = [calendar dateFromComponents:components];
    return [selfDate isEqualToDate:today];
}

- (NSDate *)vld_startOfTheWeek {
    NSDate *periodStart;
    NSTimeInterval timeInterval;
    [[NSCalendar vld_preferredCalendar] rangeOfUnit:NSWeekCalendarUnit
                                          startDate:&periodStart
                                           interval:&timeInterval
                                            forDate:self];
    return periodStart;
}

@end
