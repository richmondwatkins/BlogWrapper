//
//  Button.h
//  DailyDoll
//
//  Created by Richmond on 2/11/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SocialItem;

@interface Button : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SocialItem *socialItem;

@end
