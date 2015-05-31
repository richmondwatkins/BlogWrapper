//
//  SocialStreamWebServic.h
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialStreamWebService : NSObject

+ (void)requestTweets:(void (^)(NSArray *results))complete;

@end
