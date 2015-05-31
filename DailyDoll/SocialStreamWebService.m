//
//  SocialStreamWebServic.m
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialStreamWebService.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "ProjectSettings.h"
#import <FacebookSDK.h>

@implementation SocialStreamWebService

+ (void)requestTweets:(void (^)(NSArray *results))callback {
    
    [Fabric with:@[TwitterKit]];
    __weak typeof(self) weakSelf = self;
    [TwitterKit logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession) {
            
            NSString *twitterAccountId = [[ProjectSettings sharedManager] fetchSocialItem:TWIITER withProperty:kSocialClientId];
            NSString *twitterAccountName = [[ProjectSettings sharedManager] fetchSocialItem:TWIITER withProperty:kAccountName];
            
            NSDictionary *params = @{@"user_id": twitterAccountId};
            
            NSError *clientError;
            NSURLRequest *requesty = [[[Twitter sharedInstance] APIClient]
                                      URLRequestWithMethod:@"GET"
                                      URL:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=10", twitterAccountName]
                                      parameters:params
                                      error:&clientError];
            
            [NSURLConnection sendAsynchronousRequest:requesty queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments error:nil];
                
                callback(jsonArray);
            }];
            
        } else {
            NSLog(@"Unable to log in as guest: %@", [error localizedDescription]);
        }
    }];
}

+ (void)requestFacebookPosts:(void (^)(NSArray *results))callback {
    
//https://graph.facebook.com/1375752596010969/feed?access_token=352521494954785|hXoNpraF9qIZaZ6jJljGLsxydtI

    //352521494954785|hXoNpraF9qIZaZ6jJljGLsxydtI
}

@end
