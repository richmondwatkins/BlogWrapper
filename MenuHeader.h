//
//  MenuHeader.h
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuContainer, MenuItem;

@interface MenuHeader : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) MenuContainer *menuContainer;
@property (nonatomic, retain) NSSet *menuItems;
@end

@interface MenuHeader (CoreDataGeneratedAccessors)

- (void)addMenuItemsObject:(MenuItem *)value;
- (void)removeMenuItemsObject:(MenuItem *)value;
- (void)addMenuItems:(NSSet *)values;
- (void)removeMenuItems:(NSSet *)values;

@end
