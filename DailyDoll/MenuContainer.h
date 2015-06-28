//
//  MenuContainer.h
//  DailyDoll
//
//  Created by Richmond Watkins on 6/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuItem;

@interface MenuContainer : NSManagedObject

@property (nonatomic, retain) NSSet *menuItems;
@end

@interface MenuContainer (CoreDataGeneratedAccessors)

- (void)addMenuItemsObject:(MenuItem *)value;
- (void)removeMenuItemsObject:(MenuItem *)value;
- (void)addMenuItems:(NSSet *)values;
- (void)removeMenuItems:(NSSet *)values;

@end
