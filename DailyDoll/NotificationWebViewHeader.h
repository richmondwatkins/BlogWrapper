//
//  NotificationWebViewHeader.h
//  DailyDoll
//
//  Created by Richmond on 3/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotifcationHeader <NSObject>

- (void)animateClose;

@end

@interface NotificationWebViewHeader : UIView

@property UIButton *closeButton;

@property UILabel *dateLabel;

@property id<NotifcationHeader> delegate;

- (instancetype)initWithDate:(NSDate *)date andFrame:(CGRect)frame;

@end
