//
//  SideMenuHeaderTheme.h
//  DailyDoll
//
//  Created by Richmond on 2/10/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SideMenuHeaderTheme;

@interface SideMenuHeaderTheme : NSManagedObject

@property (nonatomic, retain) NSString * backgroundColor;
@property (nonatomic, retain) SideMenuHeaderTheme *themeElement;

@end
