//
//  StatusBarTheme.h
//  DailyDoll
//
//  Created by Richmond on 2/10/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatusBarTheme;

@interface StatusBarTheme : NSManagedObject

@property (nonatomic, retain) NSString * backgroundColor;
@property (nonatomic, retain) StatusBarTheme *themeElement;

@end
