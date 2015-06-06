//
//  ShareTableView.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareTableView.h"
#import "APIManager.h"

@implementation ShareTableView

-(instancetype)initWithStyleAndFrame:(CGRect)parentFrame {

    if (self = [super init]) {

        self.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:SHARETABLEVIEW withProperty:kBackgroundColor]];

        self.frame = parentFrame;

         self.separatorInset = UIEdgeInsetsMake(0.0f, self.frame.size.width, 0.0f, 0.0f);

    }

    return self;
}


@end
