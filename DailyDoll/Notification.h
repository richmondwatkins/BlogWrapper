//
//  Notification.h
//  DailyDoll
//
//  Created by Richmond on 3/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * receivedDate;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * isViewed;

@end
