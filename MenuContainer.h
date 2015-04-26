//
//  MenuContainer.h
//  DailyDoll
//
//  Created by Richmond Watkins on 4/25/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuGroup;

@interface MenuContainer : NSManagedObject

@property (nonatomic, retain) NSSet *menuGroup;
@end

@interface MenuContainer (CoreDataGeneratedAccessors)

- (void)addMenuGroupObject:(MenuGroup *)value;
- (void)removeMenuGroupObject:(MenuGroup *)value;
- (void)addMenuGroup:(NSSet *)values;
- (void)removeMenuGroup:(NSSet *)values;

@end
