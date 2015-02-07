//
//  SideMenuViewController.h
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDViewController.h"

@protocol SideMenuProtocol <NSObject>

- (void)selectedSideMenuItem:(NSDictionary *)navigationObject;

@end

@interface SideMenuViewController : DDViewController

@property id<SideMenuProtocol> delegate;

- (int)returnWidthForMenuViewController;

@end
