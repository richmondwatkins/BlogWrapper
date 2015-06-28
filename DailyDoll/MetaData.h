//
//  MetaData.h
//  DailyDoll
//
//  Created by Richmond Watkins on 6/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccessoryPage, ProjectVariable;

@interface MetaData : NSManagedObject

@property (nonatomic, retain) NSNumber * appId;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * siteEmail;
@property (nonatomic, retain) NSString * siteName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *accessoryPages;
@property (nonatomic, retain) ProjectVariable *projectVariable;
@end

@interface MetaData (CoreDataGeneratedAccessors)

- (void)addAccessoryPagesObject:(AccessoryPage *)value;
- (void)removeAccessoryPagesObject:(AccessoryPage *)value;
- (void)addAccessoryPages:(NSSet *)values;
- (void)removeAccessoryPages:(NSSet *)values;

@end
