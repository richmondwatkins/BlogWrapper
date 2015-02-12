//
//  MetaData.h
//  DailyDoll
//
//  Created by Richmond on 2/11/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectVariable;

@interface MetaData : NSManagedObject

@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, retain) ProjectVariable *projectVariable;

@end
