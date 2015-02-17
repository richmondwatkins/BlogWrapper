//
//  SocialShareMethods.m
//  DailyDoll
//
//  Created by Richmond on 2/16/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialShareMethods.h"
@import Social;

@implementation SocialShareMethods

//========== FACEBOOK =========
+(BOOL)shareToFaceBookWithURL:(FBLinkShareParams *)params {

    if ([FBDialogs canPresentShareDialogWithParams:params]) {

        [self shareToFacebookExternal:params];

        return YES;
    } else {
        //TODO add share items ... text and images
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {

            NSString *facebookPageName = [[ProjectSettings sharedManager] metaDataVariables:kSiteName];

            [self shareToFacebookInternal:[NSString stringWithFormat:@"%@ | %@", facebookPageName, params.link.absoluteString]];

            return YES;
        }else {

            return NO;
        }
    }

    return NO;

}

+ (void)shareToFacebookExternal:(FBLinkShareParams *) params {

    [FBDialogs presentShareDialogWithLink:params.link
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog(@"Error publishing story: %@", error.description);
                                      } else {
                                          // Success
                                          NSLog(@"result %@", results);
                                      }
                                  }];

}

+ (void)shareToFacebookInternal:(NSString *)shareContent {

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        //TODO add text and images
        [controller setInitialText:shareContent];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:controller animated:YES completion:Nil];
    }
}


//========== PINTEREST =========


+(BOOL)pinToPinterest:(NSURL *)imageURL andSource:(NSURL *)sourceURL {

    Pinterest *pinterest = [[Pinterest alloc] initWithClientId:@"1442952"];

    if ([pinterest canPinWithSDK]) {
        [pinterest createPinWithImageURL:imageURL
                                    sourceURL:sourceURL
                                  description:[[ProjectSettings sharedManager] metaDataVariables:kBlogName]];

        return YES;
    } else {

        return NO;
    }

}


//========== TWITTER =========

+ (BOOL)shareToTwitter:(NSString *)shareContent {
    //TODO add text and images to share...the title of the post
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        //TODO add text and images
        [controller setInitialText:shareContent];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:controller animated:YES completion:Nil];

        return YES;
    }else {
        //TODO ask to sign into twitter
        return NO;
    }
}

//+ (TWTRLogInButton *)returnTwitterLoginButton {
//
//    TWTRLogInButton* logInButton =  [TWTRLogInButton
//                                     buttonWithLogInCompletion:
//                                     ^(TWTRSession* session, NSError* error) {
//                                         if (session) {
//                                             NSLog(@"signed in as %@", session);
//
//                                             [[ProjectSettings sharedManager] saveSocialInteraction:TWIITER withStatus:YES];
//
//                                             UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//
//                                             self.socialPopUp = [self.actionController twitterPopConfig:mainWindow.frame];
//
//                                             [self displaySocialPoUp];
//
//                                         } else {
//                                             NSLog(@"error: %@", [error localizedDescription]);
//                                         }
//                                     }];
//    
//    [logInButton addTarget:self action:@selector(removeViewsFromWindow)
//          forControlEvents:UIControlEventTouchUpInside];
//    
//    return logInButton;
//}



//========= GOOGLE PLUS ======

+ (BOOL)shareToGooglePlus:(NSString *)shareContent {

    if ([[GPPSignIn sharedInstance] authentication]) {

        id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];

        // This line will fill out the title, description, and thumbnail from
        // the URL that you are sharing and includes a link to that URL.
        [shareBuilder setURLToShare:[NSURL URLWithString:shareContent]];

        // Optionally attach a deep link ID for your mobile app
//        [shareBuilder setContentDeepLinkID:@"/restaurant/sf/1234567/"];

        [shareBuilder open];
        
        return YES;
    }else {
        
        return NO;
    }

}


@end
