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

@protocol SocialProtocol <NSObject>

@optional

- (void)facebookShareInternal:(NSString *)shareContent;
- (void)facebookShareExternal:(FBLinkShareParams *)shareContent;
- (void)facebookLike;
- (void)facebookWebView:(NSURL *)facebookURL;

@end

@interface SocialSharingActionController : NSObject

- (SocialSharePopoverView *) facebookPopConfig:(CGRect)windoFrame;

- (SocialSharePopoverView *) handlePintrestShare;

- (SocialSharePopoverView *)  handleTwitterShare;

- (SocialSharePopoverView *) handleInstagramShare;

- (SocialSharePopoverView *)  handleGooglePlusShare;

@property id<SocialProtocol> delegate;


@end
