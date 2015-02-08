//
//  SocialSharePopoverView.m
//  DailyDoll
//
//  Created by Richmond on 2/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialSharePopoverView.h"

@implementation SocialSharePopoverView

- (instancetype)initWithParentFrame:(CGRect)windowFrame andButtons:(NSArray *)buttons {

    if (self = [super init]) {
       self.frame = CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

        UIView *popUp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowFrame.size.width * 0.8, windowFrame.size.height / 2)];
        popUp.backgroundColor = [UIColor whiteColor];
        popUp.layer.cornerRadius = 5;
        popUp.layer.shadowOpacity = 0.8;
        popUp.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

        for (UIButton *button in buttons) {
            button.frame = CGRectMake(0, 0, popUp.frame.size.width * 0.8, 40);
            UIView *lastSubView = [[popUp subviews] lastObject];

            [popUp addSubview:button];

            if (lastSubView) {

                [button setCenter:CGPointMake(popUp.frame.size.width / 2, lastSubView.center.y + button.frame.size.height + 40)];
            }else {
                [button setCenter:CGPointMake(popUp.frame.size.width / 2, popUp.frame.size.height * 0.2)];
            }



            button.backgroundColor = [UIColor greenColor];
        }

        [self addSubview:popUp];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
        [self addGestureRecognizer:tapGesture];
        
    }

    return self;
}

@end
