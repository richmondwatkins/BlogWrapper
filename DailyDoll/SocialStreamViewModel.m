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
        if (results != nil) {
            for (NSDictionary *post in results) {
                [self.socialItems addObject:[self formatTwitterPosts:post]];
            }
        }
        self.promiseCount += 1;
        [self reloadTableView];
    }];
    
    [SocialStreamWebService requestFacebookPosts:^(NSArray *results) {
        if (results != nil) {
            for (NSDictionary *post in results) {
                if (post[@"description"] != nil || post[@"picture"] != nil || post[@"link"] != nil || post[@"message"] != nil) {
                    [self.socialItems addObject:[self formatFacebookPosts:post]];
                }
            }
        }
        self.promiseCount += 1;
        [self reloadTableView];
    }];
    
    [SocialStreamWebService requestInstagramPosts:^(NSArray *results) {
        if (results != nil) {
            for (NSDictionary *post in results) {
                [self.socialItems addObject:[self formatInstagramPosts:post]];
            }
        }
        self.promiseCount += 1;
        [self reloadTableView];
    }];
}

- (NSDictionary *)formatInstagramPosts:(NSDictionary *)postData {
    
    NSDictionary *post = [[NSDictionary alloc] initWithObjectsAndKeys:
                          postData[@"caption"][@"text"], @"message",
                          postData[@"images"][@"standard_resolution"][@"url"], @"post-image",
                          @([postData[@"caption"][@"created_time"]integerValue]), @"time",
                          postData[@"link"], @"link",
                          @(NO), @"isTwitter",
                          @(NO), @"isFacebook",
                          @(YES), @"isInstagram",
                          nil];
    return post;
}

- (NSDictionary *)formatFacebookPosts:(NSDictionary *)postData {

    NSDictionary *post = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @(NO), @"isTwitter",
                          @(YES), @"isFacebook",
                          @(NO), @"isInstagram",
                          postData[@"message"], @"message",
                          postData[@"picture"], @"post-image",
                          @([postData[@"created_time"] integerValue]), @"time",
                          postData[@"link"], @"link",
                          postData[@"description"], @"link-description",
                          postData[@"images"][@"picture"], @"link-image",
                          nil];
    
    return  post;
}

- (NSDictionary *)formatTwitterPosts:(NSDictionary *)postData {
    
    NSDictionary *post = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @(YES), @"isTwitter",
                          @(NO), @"isFacebook",
                          @(NO), @"isInstagram",
                          postData[@"text"], @"message",
                          [self twitterTimeStampToUnix:postData[@"created_at"]], @"time",
                          nil];
    
    
    return  post;
}

- (NSNumber *)twitterTimeStampToUnix:(NSString *)dateString {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE LLLL d HH:mm:ss Z yyyy"];
    double date = [dateFormat dateFromString:dateString].timeIntervalSince1970;
    
    return @(date);
}

- (void)reloadTableView {
    if (self.promiseCount == 3) {
        
        NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        
        [self.socialItems sortUsingDescriptors:@[timeSort]];
        
        [self.delegate reloadTableView];
    }
}

@end
