//
//  OAuthSignInView.h
//  DailyDoll
//
//  Created by Richmond on 2/12/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OAuthSignInView : UIView

- (instancetype)initWithSubview:(UIView *)subView andParentFrame:(CGRect)parentFrame;

- (void)animateOntoScreen:(CGRect)parentFrame;

- (void)animateOffScreen;

@end
