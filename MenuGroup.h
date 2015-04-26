//
//  MenuGroup.h
//  DailyDoll
//
//  Created by Richmond Watkins on 4/25/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuContainer, MenuItem;

@interface MenuGroup : NSManagedObject

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, retain) NSNumber * isHeader;
@property (nonatomic, retain) MenuContainer *menuContainer;
@property (nonatomic, retain) NSSet *menuItems;
@end

@interface MenuGroup (CoreDataGeneratedAccessors)

- (void)addMenuItemsObject:(MenuItem *)value;
- (void)removeMenuItemsObject:(MenuItem *)value;
- (void)addMenuItems:(NSSet *)values;
- (void)removeMenuItems:(NSSet *)values;

@end
