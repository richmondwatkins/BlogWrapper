//
//  OAuthSignInView.m
//  DailyDoll
//
//  Created by Richmond on 2/12/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "OAuthSignInView.h"

@implementation OAuthSignInView

-(instancetype)initWithSubview:(UIView *)subView andParentFrame:(CGRect)parentFrame {

    if (self = [super init]) {

        self.frame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height / 4 + subView.frame.size.height);

        [self setCenter:CGPointMake(parentFrame.size.width / 2, -(self.frame.size.height / 2))];

        [self addSubview:subView];

        subView.frame = CGRectMake(0, 0, self.frame.size.width, subView.frame.size.height);

        [subView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height - (subView.frame.size.height / 2))];

        self.backgroundColor = [UIColor blueColor];
    }

    return self;
}

- (void)animateOntoScreen:(CGRect)parentFrame {

    [UIView animateWithDuration:0.3 animations:^{

        UIView *subView = [self subviews][0];

        [self setCenter:CGPointMake(parentFrame.size.width / 2, self.frame.size.height / 8 + subView.frame.size.height)];
        
    }];
}

- (void)animateOffScreen {

    [UIView animateWithDuration:0.3 animations:^{

        self.center = CGPointMake(self.center.x, -(self.frame.size.height));

        self.alpha = 0;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

@end
