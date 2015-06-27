//
//  MenuTableViewCell.h
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
#import "BATableViewCell.h"
@interface SideMenuTableViewCell : BATableViewCell

- (void)configureCell:(MenuItem *)menuItem;
- (void)flipArrowOrientation:(MenuItem *)menuItem;

@end
