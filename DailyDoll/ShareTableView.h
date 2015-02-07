//
//  ShareTableView.h
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTableView : UITableView

@property NSArray *customDataSource;

- (instancetype)initWithStyleAndFrame:(CGRect)parentFrame;

@end
