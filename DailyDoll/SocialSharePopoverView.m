//
//  SocialSharePopoverView.m
//  DailyDoll
//
//  Created by Richmond on 2/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialSharePopoverView.h"
#import "APIManager.h"
#import "FacebookSDK.h"
#import <TwitterKit/TwitterKit.h>

@interface SocialSharePopoverView () <UIGestureRecognizerDelegate>

@property BOOL facebookLikeStatus;
@end

CGFloat const kButtonPadding = 20;
CGFloat const kButtonHeight = 40;
CGFloat const kTitleHeight = 40;

@implementation SocialSharePopoverView {
}

- (instancetype)initWithParentFrame:(CGRect)windowFrame andButtons:(NSArray *)buttons andSocialSiteName:(NSString *)socialSite {

    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;


        CGFloat popUpWidth = windowFrame.size.width * 0.8;

        UIView *popUp = [[UIView alloc] initWithFrame:CGRectMake(0, windowFrame.size.height * 2, popUpWidth, (buttons.count * kButtonHeight) + (buttons.count + 1) * kButtonPadding + kTitleHeight)];

        [popUp setCenter:CGPointMake(windowFrame.size.width/2, popUp.center.y)];

        popUp.alpha = 0;
        popUp.backgroundColor = [UIColor whiteColor];
        popUp.layer.cornerRadius = 5;
        popUp.layer.shadowOpacity = 0.8;
        popUp.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, popUp.frame.size.width, kTitleHeight)];

        NSString *blogName = [[APIManager sharedManager] fetchmetaDataVariables:kBlogName];

        titleLabel.text = [NSString stringWithFormat:@"%@ on %@", blogName, socialSite];
        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;

        [popUp addSubview:titleLabel];

        [titleLabel setCenter:CGPointMake(popUp.frame.size.width /2, titleLabel.frame.size.height)];

        for (UIButton *button in buttons) {
            if ([button.titleLabel.text isEqualToString:@"Like"]) {

                [self genarateLikeButton:popUp withOriginalButton:button];

            }else {

                button.frame = CGRectMake(0, 0, popUp.frame.size.width * 0.8, kButtonHeight);

                UIView *lastSubView = [[popUp subviews] lastObject];

                [popUp addSubview:button];

                if (lastSubView && ![lastSubView isKindOfClass:[UILabel class]]) {

                    [button setCenter:CGPointMake(popUp.frame.size.width / 2,
                                                  lastSubView.center.y + button.frame.size.height + kButtonPadding)];
                }else {

                    [self setFirstButton:button withPopUp:popUp];
                }
            }
        }

        [self addSubview:popUp];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }

    return self;
}

- (void)setFirstButton:(UIControl *)button withPopUp:(UIView *)popUp {

     [button setCenter:CGPointMake(popUp.frame.size.width / 2,
                                 (kButtonPadding + kTitleHeight) + kTitleHeight / 3)];
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

        if (self.subviews.count) {
            UIView *popUpSubView = self.subviews[0];

            popUpSubView.center = CGPointMake(self.center.x, self.frame.size.height * 2);

            popUpSubView.alpha = 0;
        }

        self.alpha = 0;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

- (void)removeChildView {

    UIView *popUpSubView = self.subviews[0];


    [UIView animateWithDuration:0.3 animations:^{

        popUpSubView.center = CGPointMake(self.center.x, self.frame.size.height * 2);

        popUpSubView.alpha = 0;

    } completion:^(BOOL finished) {

        [popUpSubView removeFromSuperview];
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {

    [self.delegate removeViewsFromWindow];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.subviews.count) {
        UIView *popUp = self.subviews[0];

        if (CGRectContainsPoint(popUp.bounds, [touch locationInView:popUp])) {

            return NO;
        } else {
            
            return YES;
        }

    } else {
        return YES;
    }


}


- (void)genarateLikeButton:(UIView *)popUp withOriginalButton:(UIButton *)button {

    [FBSettings enablePlatformCompatibility:NO];

    NSString *buttonTitle;

   self.facebookLikeStatus = [[APIManager sharedManager] hasInteractedWithSocialItem:FACEBOOK];

    if (self.facebookLikeStatus) {
        buttonTitle = @"Liked";
    }else {
        buttonTitle = @"Like";
    }


    FBLikeControl *like = [[FBLikeControl alloc] initWithFrame:CGRectMake(0, 0, popUp.frame.size.width * 0.8, kButtonHeight) andTitle:buttonTitle];

    like.objectID = [[APIManager sharedManager] fetchSocialItem:FACEBOOK withProperty:kSocialAccountURL];
    like.preferredMaxLayoutWidth = 300;
    like.likeControlStyle = FBLikeControlStyleButton;
    like.likeControlAuxiliaryPosition = FBLikeControlHorizontalAlignmentCenter;

    UIView *lastSubView = [[popUp subviews] lastObject];

    if (lastSubView && ![lastSubView isKindOfClass:[UILabel class]]) {
        
        [like setCenter:CGPointMake(popUp.frame.size.width / 2,
                                      lastSubView.center.y + button.frame.size.height + kButtonPadding)];
    }else {
        
        [self setFirstButton:like withPopUp:popUp];
    }

    [popUp addSubview:like];

    [like addTarget:self action:@selector(handleFacebookLike:) forControlEvents:UIControlEventTouchUpInside];

}

//TODO Handle facebook like text
- (void)handleFacebookLike:(UIButton *)button {

    if (self.facebookLikeStatus) {
//       [button setTitle:@"Liked" forState:UIControlStateNormal];
    }else {
//        [button setTitle:@"Liked" forState:UIControlStateNormal];
    }

    [[APIManager sharedManager] saveSocialInteraction:FACEBOOK withStatus:!self.facebookLikeStatus];


}

@end
