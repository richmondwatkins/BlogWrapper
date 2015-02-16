//
//  MenuItem.h
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuHeader;

@interface MenuItem : NSManagedObject

@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) MenuHeader *menuHeader;

@end
