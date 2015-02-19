//
//  SideMenuHeaderImageView.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuHeaderImageView.h"

@implementation SideMenuHeaderImageView

-(instancetype)initWithParentFrame:(CGRect)parentFrame andMenuVCWidth:(int)menuWidth {

    if (self = [super init]) {

        self.image = [UIImage imageNamed:@"logo"];

        self.contentMode = UIViewContentModeScaleAspectFill;

        CGFloat height = self.image.size.height;

        self.frame = CGRectMake(0, 0, menuWidth / 2, height);

    }

    return self;
}
@end
