//
//  NotificationTableViewCell.h
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATableViewCell.h"
#import "Notification.h"
@interface NotificationTableViewCell : BATableViewCell

- (void)configureCell:(Notification *)cellContents;

@end
