//
//  MetaData.h
//  DailyDoll
//
//  Created by Richmond on 2/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccessoryPage, ProjectVariable;

@interface MetaData : NSManagedObject

@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) ProjectVariable *projectVariable;
@property (nonatomic, retain) NSSet *accessoryPages;
@property (nonatomic, retain) NSNumber *appId;
@end

@interface MetaData (CoreDataGeneratedAccessors)

- (void)addAccessoryPagesObject:(AccessoryPage *)value;
- (void)removeAccessoryPagesObject:(AccessoryPage *)value;
- (void)addAccessoryPages:(NSSet *)values;
- (void)removeAccessoryPages:(NSSet *)values;

@end
