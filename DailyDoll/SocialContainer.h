//
//  SocialContainer.h
//  DailyDoll
//
//  Created by Richmond on 2/11/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectVariable, SocialItem;

@interface SocialContainer : NSManagedObject

@property (nonatomic, retain) ProjectVariable *projectVariable;
@property (nonatomic, retain) NSSet *socialItems;
@end

@interface SocialContainer (CoreDataGeneratedAccessors)

- (void)addSocialItemsObject:(SocialItem *)value;
- (void)removeSocialItemsObject:(SocialItem *)value;
- (void)addSocialItems:(NSSet *)values;
- (void)removeSocialItems:(NSSet *)values;

@end
