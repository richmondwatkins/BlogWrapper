//
//  MenuItem.h
//  DailyDoll
//
//  Created by Richmond Watkins on 4/25/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuGroup, MenuItem;

@interface MenuItem : NSManagedObject

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * isHeader;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) MenuGroup *menuGroup;
@property (nonatomic, retain) NSSet *children;

@end

@interface MenuItem (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(MenuItem *)value;
- (void)removeChildrenObject:(MenuItem *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
