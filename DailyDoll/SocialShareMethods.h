//
//  SocialShareMethods.h
//  DailyDoll
//
//  Created by Richmond on 2/16/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Pinterest/Pinterest.h>
#import <TwitterKit/TwitterKit.h>

#import "ProjectSettings.h"

@interface SocialShareMethods : NSObject


+(BOOL)shareToFaceBookWithURL:(FBLinkShareParams *)params;

+(BOOL)pinToPinterest:(NSURL *)imageURL andSource:(NSURL *)sourceURL;

+ (BOOL)shareToTwitter:(NSString *)shareContent;

@end
