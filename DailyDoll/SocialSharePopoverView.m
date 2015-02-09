//
//  SocialSharePopoverView.m
//  DailyDoll
//
//  Created by Richmond on 2/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialSharePopoverView.h"
#import "ProjectSettings.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SocialSharePopoverView () <UIGestureRecognizerDelegate>

@end

@implementation SocialSharePopoverView

- (instancetype)initWithParentFrame:(CGRect)windowFrame andButtons:(NSArray *)buttons {

    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;

        UIView *popUp = [[UIView alloc] initWithFrame:CGRectMake(0, windowFrame.size.height * 2, windowFrame.size.width * 0.8, windowFrame.size.height / 2)];
        popUp.alpha = 0;
        popUp.backgroundColor = [UIColor whiteColor];
        popUp.layer.cornerRadius = 5;
        popUp.layer.shadowOpacity = 0.8;
        popUp.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

        for (UIButton *button in buttons) {
            if ([button.titleLabel.text isEqualToString:@"Like"]) {

                [self genarateLikeButton:popUp withOriginalButton:button];
            }else {

                button.frame = CGRectMake(0, 0, popUp.frame.size.width * 0.8, 40);

                UIView *lastSubView = [[popUp subviews] lastObject];

                [popUp addSubview:button];

                if (lastSubView) {

                    [button setCenter:CGPointMake(popUp.frame.size.width / 2,
                                                  lastSubView.center.y + button.frame.size.height + 40)];
                }else {
                    [button setCenter:CGPointMake(popUp.frame.size.width / 2,
                                                  popUp.frame.size.height * 0.2)];
                }
                
                
                button.backgroundColor = [UIColor greenColor];
            }
        }

        [self addSubview:popUp];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }

    return self;
}



- (void)animateOnToScreen {

    [UIView animateWithDuration:0.3 animations:^{

        UIView *popUpSubView = self.subviews[0];

        popUpSubView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height);

        popUpSubView.alpha = 1;

        self.alpha = 1;

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    }];
}

- (void)animateOffScreen {

    [UIView animateWithDuration:0.3 animations:^{

        UIView *popUpSubView = self.subviews[0];

        popUpSubView.center = CGPointMake(self.center.x, self.frame.size.height * 2);

        popUpSubView.alpha = 0;

        self.alpha = 0;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {

    [UIView animateWithDuration:0.3 animations:^{

        UIView *popUpSubView = self.subviews[0];

        popUpSubView.alpha = 0;

        self.alpha = 0;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *popUp = self.subviews[0];

    if (CGRectContainsPoint(popUp.bounds, [touch locationInView:popUp])) {

        return NO;
    }

    return YES;
}

- (void)genarateLikeButton:(UIView *)popUp withOriginalButton:(UIButton *)button {

    [FBSettings enablePlatformCompatibility:NO];

    FBLikeControl *like = [[FBLikeControl alloc] initWithFrame:CGRectMake(0, 0, popUp.frame.size.width * 0.8, 40)];

    like.objectID = @"http://shareitexampleapp.parseapp.com/photo1/";
    [popUp addSubview:like];
    like.preferredMaxLayoutWidth = 300;
    like.likeControlStyle = FBLikeControlStyleButton;
    like.likeControlAuxiliaryPosition = FBLikeControlHorizontalAlignmentCenter;

    UIView *lastSubView = [[popUp subviews] lastObject];
    if (lastSubView) {

        [like setCenter:CGPointMake(popUp.frame.size.width / 2, lastSubView.center.y + button.frame.size.height + 40)];
    }else {
        [like setCenter:CGPointMake(popUp.frame.size.width / 2, popUp.frame.size.height * 0.2)];
    }
}


@end
