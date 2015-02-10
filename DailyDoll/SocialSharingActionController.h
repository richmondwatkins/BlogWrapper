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
#import <FacebookSDK/FacebookSDK.h>
#import <Pinterest/Pinterest.h>

@protocol SocialProtocol <NSObject>

@optional

- (void)facebookShareInternal:(NSString *)shareContent;
- (void)facebookShareExternal:(FBLinkShareParams *)shareContent;
- (void)facebookLike;
- (void)socialWebView:(NSURL *)facebookURL;

@end

@interface SocialSharingActionController : NSObject

@property Pinterest *pinterest;

- (SocialSharePopoverView *) facebookPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) pintrestPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) twitterPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) instagramPopConfig:(CGRect)windowFrame;

- (SocialSharePopoverView *) googlePlusPopConfig:(CGRect)windowFrame;

@property id<SocialProtocol> delegate;


@end
