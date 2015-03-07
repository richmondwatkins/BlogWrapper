//
//  NotificationWebView.h
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"
@interface NotificationWebView : UIWebView

- (instancetype)initWithCellRect:(CGRect)touchPoint andParentFrame:(CGRect)parentFrame andContent:(Notification *)notification;

- (void)animateOpen:(CGRect)parentRect withNotification:(Notification *)notification;

@end
