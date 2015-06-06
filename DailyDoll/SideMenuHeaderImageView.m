//
//  SideMenuHeaderImageView.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuHeaderImageView.h"
#import "APIManager.h"

@implementation SideMenuHeaderImageView

-(instancetype)initWithParentFrame:(CGRect)parentFrame andMenuVCWidth:(int)menuWidth {

    if (self = [super init]) {

        self.image = [[APIManager sharedManager] fetchLogoImage];

        self.frame = CGRectMake(0, 0, self.image.size.width/2, self.image.size.height/2);

    }

    return self;
}
@end
