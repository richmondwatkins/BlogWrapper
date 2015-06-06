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
#import "APIManager.h"
#import <FacebookSDK.h>

@implementation SocialStreamWebService

+ (void)requestTweets:(void (^)(NSArray *results))callback {
    
    [Fabric with:@[TwitterKit]];
    __weak typeof(self) weakSelf = self;
    [TwitterKit logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession) {
            
            NSString *twitterAccountId = [[APIManager sharedManager] fetchSocialItem:TWIITER withProperty:kSocialClientId];
            NSString *twitterAccountName = [[APIManager sharedManager] fetchSocialItem:TWIITER withProperty:kAccountName];
            
            NSDictionary *params = @{@"user_id": twitterAccountId};
            
            NSError *clientError;
            NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                                      URLRequestWithMethod:@"GET"
                                      URL:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=10", twitterAccountName]
                                      parameters:params
                                      error:&clientError];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
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
    
    NSString *facebookAuthToken = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                          pathForResource:@"ProjectVariables"
                                                                          ofType:@"plist"]][kFacebookAuthToken];
    
    NSString *facebookID = [[APIManager sharedManager] fetchSocialItem:FACEBOOK withProperty:kSocialClientId];
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/feed?access_token=%@", facebookID, facebookAuthToken];
    NSString *encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:encodedUrlString];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments error:nil];
        
        callback(json[@"data"]);
    }];

}

+ (void)requestInstagramPosts:(void (^)(NSArray *results))callback {
    
    NSString *instagramAuthToken = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                              pathForResource:@"ProjectVariables"
                                                                              ofType:@"plist"]][kInstagramAuthToken];
    
    NSString *instagramID = [[APIManager sharedManager] fetchSocialItem:INSTAGRAM withProperty:kSocialClientId];
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", instagramID, instagramAuthToken];

    NSString *encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodedUrlString];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments error:nil];
        
        callback(json[@"data"]);
    }];
    
}

@end
