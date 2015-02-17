//
//  ProjectSettingsKeys.h
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FACEBOOK,
    PINTEREST,
    TWIITER,
    INSTAGRAM,
    GOOGLEPLUS
} SocialType;

typedef enum {
    ACTIVITYINDICATOR,
    NAVBAR,
    SHARETABLEVIEW,
    SHAREVIEW,
    SIDEMENUCELL,
    SIDEMENUHEADER,
    SIDEMENUSECTIONHEADER,
    SIDEMENUTABLEVIEW,
    STATUSBAR
} Theme;


@interface ProjectSettingsKeys : NSObject

extern NSString *const kBackgroundColor;

extern NSString *const kTintColor;

extern NSString *const kFontFamily;

extern NSString *const kFontColor;

extern NSString *const kTitle;

extern NSString *const kURLString;

extern NSString *const kImage;

extern NSString *const kBlogName;

extern NSString *const kInstagramAuthorizationUrl;

extern NSString *const kInstagramBaseUrl;

extern NSString *const kInstagramAppRedirectURL;

extern NSString *const kSocialClientId;

extern NSString *const kFirstStartUp;

//Social

extern NSString *const kInstagram;

extern NSString *const kFacebook;

extern NSString *const kTwitter;

extern NSString *const kPintrest;

extern NSString *const kGooglePlus;

extern NSString *const kButtons;

extern NSString *const kAccountName;

//Theme Elements

extern NSString *const kNavBar;

extern NSString *const kStatusBar;

extern NSString *const kSideMenuHeader;

extern NSString *const kSideMenuTableView;

extern NSString *const kSideMenuCell;

extern NSString *const kSideMenuSectionHeader;

extern NSString *const kShareView;

extern NSString *const kActivityIndicator;

extern NSString *const kShareTableView;

//Meta Data

extern NSString *const kDomainString;

extern NSString *const kSiteName;


// Key Chain

extern NSString *const kTwitterAuthToken;

extern NSString *const kTwitterAuthSecret;

extern NSString *const kTwitteruserName;

extern NSString *const kTwitteruserId;


// Menu Items

extern NSString *const kMenuItem;

@end
