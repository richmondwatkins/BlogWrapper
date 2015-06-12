//
//  ProjectSettingsKeys.h
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FACEBOOK = 0,
    PINTEREST = 1,
    TWIITER = 2,
    INSTAGRAM = 3,
    GOOGLEPLUS = 4,
    EMAIL = 5,
    SMS = 6
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

extern NSString *const kPlatformId;

extern NSString *const kSocialAccountURL;

extern NSString *const kSeedApp;

extern NSString *const kFirstStartUp;

//Social

extern NSString *const kInstagram;

extern NSString *const kFacebook;

extern NSString *const kTwitter;

extern NSString *const kPintrest;

extern NSString *const kGooglePlus;

extern NSString *const kButtons;

extern NSString *const kAccountName;

extern NSString *const kPageID;

extern NSString *const kFacebookAuthToken;

extern NSString *const kInstagramAuthToken;


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

extern NSString *const kPrimaryColor;

extern NSString *const kSecondaryColor;

//Meta Data

extern NSString *const kDomainString;

extern NSString *const kSiteName;

extern NSString *const kMetaData;

extern NSString *const kAccessoryPages;

extern NSString *const kSiteEmail;

// Key Chain

extern NSString *const kTwitterAuthToken;

extern NSString *const kTwitterAuthSecret;

extern NSString *const kTwitteruserName;

extern NSString *const kTwitteruserId;


// Menu Items

extern NSString *const kMenuItem;

// Notification Table

extern int const kNotificationCellSize;

@end
