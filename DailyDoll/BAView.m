//
//  BAView.m
//  DailyDoll
//
//  Created by Richmond on 3/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "BAView.h"

@implementation BAView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)removeFromSuperview {

    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    }completion:^(BOOL finished) {

         [super removeFromSuperview];
    }];
}

@end
