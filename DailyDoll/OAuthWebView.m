//
//  OAuthWebView.m
//  DailyDoll
//
//  Created by Richmond on 2/13/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "OAuthWebView.h"
#import "ProjectSettings.h"

@implementation OAuthWebView

- (instancetype)initForInstagram:(CGRect)parentFrame {

    if (self= [super init]) {

        NSString *authorizationURLConfigKey = [[ProjectSettings sharedManager] fetchSocialItem:INSTAGRAM withProperty:kInstagramAuthorizationUrl];
        NSString *instagramKitAppClientId = [[ProjectSettings sharedManager]fetchSocialItem:INSTAGRAM withProperty:kInstagramAppClientId];
        NSString *instagramKitAppRedirectURL = [[ProjectSettings sharedManager]fetchSocialItem:INSTAGRAM withProperty:kInstagramAppRedirectURL];

        self.urlToLoad = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=relationships", authorizationURLConfigKey, instagramKitAppClientId, instagramKitAppRedirectURL]];

        self.frame = CGRectMake(0, 0, parentFrame.size.width, 220);
    }

    return self;
}


@end
