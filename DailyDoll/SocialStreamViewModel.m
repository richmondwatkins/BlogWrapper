//
//  SocialStreamViewModel.m
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialStreamViewModel.h"
#import "SocialStreamWebService.h"

@interface SocialStreamViewModel()

@property int promiseCount;
@property NSMutableArray *socialItems;

@end

@implementation SocialStreamViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self requestSocialData];
    }
    
    return self;
}

- (void)requestSocialData {
    
    self.socialItems = [NSMutableArray array];
    
    [SocialStreamWebService requestTweets:^(NSArray *results) {
        for (NSDictionary *post in results) {
            [self.socialItems addObject:[self formatTwitterPosts:post]];
        }
    }];
    
    [SocialStreamWebService requestFacebookPosts:^(NSArray *results) {
        for (NSDictionary *post in results) {
            [self.socialItems addObject:[self formatFacebookPosts:post]];
        }
    }];
    
    [SocialStreamWebService requestInstagramPosts:^(NSArray *results) {
        for (NSDictionary *post in results) {
           [self.socialItems addObject:[self formatInstagramPosts:post]];
        }
    }];
}

- (NSDictionary *)formatInstagramPosts:(NSDictionary *)postData {
    
    NSDictionary *post = [[NSDictionary alloc] initWithObjectsAndKeys:
                          postData[@"caption"][@"text"], @"body",
                          postData[@"images"][@"standard_resolution"][@"url"], @"post-image",
                          postData[@"caption"][@"created_time"], @"time",
                          postData[@"link"], @"link",
                          nil];
    return post;
}

- (NSDictionary *)formatFacebookPosts:(NSDictionary *)postData {
    
    NSDictionary *post = [[NSDictionary alloc] initWithObjectsAndKeys:
                          postData[@"description"], @"body",
                          postData[@"picture"], @"post-image",
                          postData[@"created_time"], @"time",
                          postData[@"link"], @"link",
                          postData[@"message"], @"link-message",
                          postData[@"images"][@"picture"], @"link-image",
                          nil];
    
    return  post;
}

- (NSDictionary *)formatTwitterPosts:(NSDictionary *)postData {
    
    NSDictionary *post = [[NSDictionary alloc] initWithObjectsAndKeys:
                          postData[@"text"], @"body",
                          postData[@"created_at"], @"time",
                          nil];
    
    return  post;
}

- (void)reloadTableView {
    
}

@end
