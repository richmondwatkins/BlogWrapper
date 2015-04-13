//
//  NSDate+Additions.m
//  DailyDoll
//
//  Created by Richmond Watkins on 4/12/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (int)daysBetween:(NSDate *)dt2 {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:dt2 options:0];
    return (int)[components day]+1;
}
@end
