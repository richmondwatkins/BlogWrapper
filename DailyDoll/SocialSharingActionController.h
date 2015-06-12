//
//  SocialSharingActionController.h
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SocialSharePopoverView.h"
#import "FacebookSDK.h"
#import <Pinterest/Pinterest.h>
#import <TwitterKit/TwitterKit.h>

@protocol SocialProtocol <NSObject>

@optional

- (void)facebookShareInternal:(NSString *)shareContent;
- (void)facebookShareExternal:(FBLinkShareParams *)shareContent;
- (void)socialWebView:(NSURL *)facebookURL;
- (void)instagramAuthWebView:(NSURL *)instagramURL;
- (void)instantiateOAuthLoginView:(int)socialType;

@end

@interface SocialSharingActionController : NSObject

@property id<SocialProtocol> delegate;

@property Pinterest *pinterest;

- (SocialSharePopoverView *) facebookPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) pintrestPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) twitterPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) instagramPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) googlePlusPopConfig:(CGRect)windowFrame;

-(void)createFollowRelationshipWithTwitter:(TWTRSession *)twitterSession withFollowButton:(UIButton *)button;


@end
