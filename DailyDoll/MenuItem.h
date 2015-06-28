//
//  MenuItem.h
//  DailyDoll
//
//  Created by Richmond Watkins on 6/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuContainer, MenuItem;

@interface MenuItem : NSManagedObject

@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSNumber * isHeader;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * isDropdown;
@property (nonatomic, retain) NSNumber * collapsable;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) MenuContainer *menuContainer;
@end

@interface MenuItem (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(MenuItem *)value;
- (void)removeChildrenObject:(MenuItem *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
