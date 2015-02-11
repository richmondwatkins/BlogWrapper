//
//  ShareTableViewTheme.h
//  DailyDoll
//
//  Created by Richmond on 2/10/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ThemeElement;

@interface ShareTableViewTheme : NSManagedObject

@property (nonatomic, retain) NSString * backgroundColor;
@property (nonatomic, retain) ThemeElement *themeElement;

@end
