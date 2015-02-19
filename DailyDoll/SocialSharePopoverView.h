//
//  SocialSharePopoverView.h
//  DailyDoll
//
//  Created by Richmond on 2/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SocialPopUp <NSObject>

@optional
- (void)removeViewsFromWindow;

@end

@interface SocialSharePopoverView : UIView

@property id<SocialPopUp> delegate;

- (instancetype)initWithParentFrame:(CGRect)windowFrame andButtons:(NSArray *)buttons andSocialSiteName:(NSString *)socialSite;

- (void)animateOffScreen;

- (void)animateOnToScreen;

- (void)removeChildView;

@end
