//
//  SideMenuTableHeaderView.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableHeaderView.h"

@implementation SideMenuTableHeaderView

- (instancetype)initWithFrame:(CGRect)parentFrame menuInset:(int)menuInset andImageView:(CGRect)imageViewFrame {

    if (self = [super init]) {

        self.frame = CGRectMake(0, 0, menuInset, imageViewFrame.size.height);

    }

    return self;
}

@end
