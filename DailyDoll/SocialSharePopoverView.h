//
//  SocialSharePopoverView.h
//  DailyDoll
//
//  Created by Richmond on 2/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocialSharePopoverView : UIView


- (instancetype)initWithParentFrame:(CGRect)windowFrame andButtons:(NSArray *)buttons;

- (void)animateOffScreen;

- (void)animateOnToScreen;

@end
