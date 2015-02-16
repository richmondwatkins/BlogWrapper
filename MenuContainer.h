//
//  MenuContainer.h
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuHeader;

@interface MenuContainer : NSManagedObject

@property (nonatomic, retain) NSSet *menuHeader;
@end

@interface MenuContainer (CoreDataGeneratedAccessors)

- (void)addMenuHeaderObject:(MenuHeader *)value;
- (void)removeMenuHeaderObject:(MenuHeader *)value;
- (void)addMenuHeader:(NSSet *)values;
- (void)removeMenuHeader:(NSSet *)values;

@end
