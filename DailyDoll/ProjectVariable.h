//
//  ProjectVariable.h
//  DailyDoll
//
//  Created by Richmond on 2/11/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MetaData, SocialContainer;

@interface ProjectVariable : NSManagedObject

@property (nonatomic, retain) MetaData *metaData;
@property (nonatomic, retain) SocialContainer *socialContainer;

@end
