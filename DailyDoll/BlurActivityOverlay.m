//
//  BlurActivityOverlay.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "BlurActivityOverlay.h"

@implementation BlurActivityOverlay

-(void)animateAndRemove {

    [UIView animateWithDuration:1.3 animations:^{

        self.alpha = 0;
    } completion:^(BOOL finished) {

        [self removeFromSuperview];
        
    }];

}

@end
