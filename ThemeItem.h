//
//  ThemeItem.h
//  DailyDoll
//
//  Created by Richmond on 2/12/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ThemeItem;

@interface ThemeItem : NSManagedObject

@property (nonatomic, retain) NSString * backgroundColor;
@property (nonatomic, retain) NSString * fontFamily;
@property (nonatomic, retain) NSString * fontColor;
@property (nonatomic, retain) ThemeItem *themeContainer;

@end
