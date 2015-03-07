//
//  DetailNavigationBar.h
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailNavigationBar : UINavigationBar

@property UIBarButtonItem *rightBarButton;

- (instancetype)initWithCloseButtonAndFrame:(CGRect)frame;
@end
