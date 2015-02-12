//
//  ThemeContainer.h
//  DailyDoll
//
//  Created by Richmond on 2/12/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ThemeContainer : NSManagedObject

@property (nonatomic, retain) NSString * primaryColor;
@property (nonatomic, retain) NSString * secondaryColor;
@property (nonatomic, retain) NSSet *themeItem;
@end

@interface ThemeContainer (CoreDataGeneratedAccessors)

- (void)addThemeItemObject:(NSManagedObject *)value;
- (void)removeThemeItemObject:(NSManagedObject *)value;
- (void)addThemeItem:(NSSet *)values;
- (void)removeThemeItem:(NSSet *)values;

@end
