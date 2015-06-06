//
//  OAuthWebView.m
//  DailyDoll
//
//  Created by Richmond on 2/13/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "OAuthWebView.h"
#import "APIManager.h"
@implementation OAuthWebView

- (instancetype)initForInstagram:(CGRect)parentFrame {

    if (self= [super init]) {

        NSString *authorizationURLConfigKey = [[APIManager sharedManager] fetchSocialItem:INSTAGRAM withProperty:kInstagramAuthorizationUrl];
        NSString *instagramKitAppClientId = [[APIManager sharedManager]fetchSocialItem:INSTAGRAM withProperty:kSocialClientId];
        NSString *instagramKitAppRedirectURL = [[APIManager sharedManager]fetchSocialItem:INSTAGRAM withProperty:kInstagramAppRedirectURL];

        self.urlToLoad = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=relationships", authorizationURLConfigKey, instagramKitAppClientId, instagramKitAppRedirectURL]];

        self.frame = CGRectMake(0, 0, parentFrame.size.width, 220);

        [self setBackgroundColor:[UIColor colorWithHexString:@"517fa4"]];
        [self setOpaque:NO];

        self.activityIndicator = [[CenterVCActivityIndicator alloc] initWithStyle];

        [self addSubview:self.activityIndicator];

        [self.activityIndicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }

    return self;
}


@end
