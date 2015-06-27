//
//  DropDownImageView.m
//  DailyDoll
//
//  Created by Richmond Watkins on 6/27/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DropDownImageView.h"

@implementation DropDownImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        
        self.isDown = YES;
    }
    
    return self;
}


@end
