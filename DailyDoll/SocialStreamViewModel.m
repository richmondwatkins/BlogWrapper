//
//  SocialStreamViewModel.m
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialStreamViewModel.h"
#import "SocialStreamWebService.h"

@implementation SocialStreamViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self requestSocialData];
    }
    
    return self;
}

- (void)requestSocialData {
    [SocialStreamWebService requestTweets:^(NSArray *results) {
        NSLog(@"%@", results);
    }];
}

@end
