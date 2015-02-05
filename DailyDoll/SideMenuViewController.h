//
//  SideMenuViewController.h
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideMenuProtocol <NSObject>

- (void)selectedSideMenuItem:(NSDictionary *)navigationObject;

@end

@interface SideMenuViewController : UIViewController

@property id<SideMenuProtocol> delegate;

@end
