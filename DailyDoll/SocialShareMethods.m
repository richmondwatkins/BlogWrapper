//
//  SocialShareMethods.m
//  DailyDoll
//
//  Created by Richmond on 2/16/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialShareMethods.h"
#import <MessageUI/MFMailComposeViewController.h>

@import Social;
@import MessageUI;

@interface SocialShareMethods () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation SocialShareMethods


static SocialShareMethods *sharedSocialManager = nil;

+ (SocialShareMethods *)sharedManager {
    @synchronized([SocialShareMethods class]){
        if (sharedSocialManager == nil) {
            sharedSocialManager = [[self alloc] init];
        }

        return sharedSocialManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([SocialShareMethods class])
    {
        NSAssert(sharedSocialManager == nil, @"Singleton already initialized.");
        sharedSocialManager = [super alloc];
        return sharedSocialManager;
    }
    return nil;
}

//========== FACEBOOK =========

- (BOOL)shareToFaceBookWithURL:(FBLinkShareParams *)params {

    if ([FBDialogs canPresentShareDialogWithParams:params]) {

        [self shareToFacebookExternal:params];

        return YES;
    } else {

        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {

            NSString *facebookPageName = [[APIManager sharedManager] fetchmetaDataVariables:kSiteName];

            [self shareToFacebookInternal:[NSString stringWithFormat:@"%@ | %@", facebookPageName, params.link.absoluteString]];

            return YES;
        }else {

            return NO;
        }
    }

    return NO;

}

- (void)shareToFacebookExternal:(FBLinkShareParams *) params {

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

- (void)shareToFacebookInternal:(NSString *)shareContent {

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        [controller addImage:[[APIManager sharedManager] fetchLogoImage]];
        [controller setInitialText:shareContent];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:controller animated:YES completion:Nil];
    }
}


//========== PINTEREST =========

- (BOOL)pinToPinterest:(NSURL *)imageURL andSource:(NSURL *)sourceURL {

    Pinterest *pinterest = [[Pinterest alloc] initWithClientId:@"1442952"];

    if ([pinterest canPinWithSDK]) {
        [pinterest createPinWithImageURL:imageURL
                                    sourceURL:sourceURL
                                  description:[[APIManager sharedManager] fetchmetaDataVariables:kBlogName]];

        return YES;
    } else {

        return NO;
    }

}


//========== TWITTER =========

- (BOOL)shareToTwitter:(NSString *)shareContent {
    //TODO add text and images to share...the title of the post
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

        [controller addImage:[[APIManager sharedManager] fetchLogoImage]];
        [controller setInitialText:shareContent];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:controller animated:YES completion:Nil];

        return YES;
    }else {
        //TODO ask to sign into twitter
        return NO;
    }
}


-(void)createFollowRelationshipWithTwitter:(TWTRSession *)twitterSession withFollowButton:(UIButton *)button {

    NSString *statusesShowEndpoint;

    BOOL isFollowing = [[APIManager sharedManager] hasInteractedWithSocialItem:TWIITER];

    if (!isFollowing) {

        statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/create.json?follow=true";

        [button setTitle:@"Following" forState:UIControlStateNormal];
    }else {

        statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/destroy.json?";

        [button setTitle:@"Follow" forState:UIControlStateNormal];
    }

    [[APIManager sharedManager] saveSocialInteraction:TWIITER withStatus:!isFollowing];

    //TODO add activity indicator in button to show request

    NSString *pageid = [[APIManager sharedManager] fetchSocialItem:TWIITER withProperty:kPageID];

    NSDictionary *params = @{@"user_id" : pageid};

    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"POST"
                             URL:statusesShowEndpoint
                             parameters:params
                             error:&clientError];

    if (request) {
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 // handle the response data e.g.
                 NSError *jsonError;
                 NSDictionary *json = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];

                 NSLog(@"RESPONSE: %@",json);
             }
             else {
                 NSLog(@"Error: %@", connectionError);
             }
         }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
    
}

//========= GOOGLE PLUS ======

- (BOOL)shareToGooglePlus:(NSString *)shareContent {

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


-(void)shareViaEmail:(NSDictionary *)messageComponents {

    if ([MFMailComposeViewController canSendMail]) {

        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];

        controller.mailComposeDelegate = self;


        if ([messageComponents objectForKey:@"recipient"]) {

            [controller setToRecipients:@[messageComponents[@"recipient"]]];
        }


        if ([messageComponents objectForKey:@"subject"]) {

            [controller setSubject:messageComponents[@"subject"]];
        }

        if ([messageComponents objectForKey:@"message"]) {

            [controller setMessageBody:messageComponents[@"message"] isHTML:NO];
        }

        if (controller) [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:nil];
    } else {
        // TODO handle when device does not have email
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareViaSMS:(NSDictionary *)messageComponents {

    if([MFMessageComposeViewController canSendText]) {


        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:messageComponents[@"message"]];

        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:messageController animated:YES completion:nil];
    }else {
        //TODO handle error for devices that don't send texts
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];

}

@end
