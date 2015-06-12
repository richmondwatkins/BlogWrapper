//
//  SocialShareMethods.h
//  DailyDoll
//
//  Created by Richmond on 2/16/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"
#import <Pinterest/Pinterest.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GooglePlus.h>

#import "APIManager.h"

@interface SocialShareMethods : NSObject

+ (SocialShareMethods *)sharedManager;

- (BOOL)shareToFaceBookWithURL:(FBLinkShareParams *)params;

- (BOOL)pinToPinterest:(NSURL *)imageURL andSource:(NSURL *)sourceURL;

- (BOOL)shareToTwitter:(NSString *)shareContent;

- (BOOL)shareToGooglePlus:(NSString *)shareContent;

- (void)shareViaEmail:(NSDictionary *)messageComponents;

- (void)shareViaSMS:(NSDictionary *)messageComponents;

@end
