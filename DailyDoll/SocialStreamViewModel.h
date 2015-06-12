//
//  SocialStreamViewModel.h
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocialStreamProtocol <NSObject>

- (void)reloadTableView;

@end

@interface SocialStreamViewModel : NSObject

@property id<SocialStreamProtocol> delegate;
@property NSMutableArray *socialItems;

- (instancetype)init;

@end
