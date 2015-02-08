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

@protocol SocialProtocol <NSObject>

@optional

- (void)facebookShare:(NSString *)shareContent;

@end

@interface SocialSharingActionController : NSObject

@property id<SocialProtocol> delegate;

- (SocialSharePopoverView *) facebookPopConfig:(CGRect)windoFrame;

+ (void) handlePintrestShare;

+ (void) handleTwitterShare;

+ (void) handleInstagramShare;

+ (void) handleGooglePlusShare;


@end
