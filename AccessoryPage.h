//
//  AccessoryPage.h
//  DailyDoll
//
//  Created by Richmond on 2/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MetaData;

@interface AccessoryPage : NSManagedObject

@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MetaData *metaData;

@end
