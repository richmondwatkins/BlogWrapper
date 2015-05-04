//
//  NotificationView.m
//  DailyDoll
//
//  Created by Richmond on 3/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationView.h"

@interface NotificationView ()

@property CGFloat caretHeight;

@end

@implementation NotificationView

- (instancetype)initWithFrame:(CGRect)frame andCaretHeight:(CGFloat)caretHeight {

    if (self = [super init]) {

        self.frame = frame;

        self.caretHeight = caretHeight;
        
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
        
        self.layer.mask = maskLayer;
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{

    UIBezierPath *fillPath = [UIBezierPath bezierPath];

    CGFloat baseLineY = self.bounds.origin.y + self.caretHeight;

    [fillPath moveToPoint:CGPointMake(self.bounds.origin.x, baseLineY)];

    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width-(self.caretHeight), baseLineY)];
    
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.origin.y)];

    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, baseLineY)];

    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];

    [fillPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];

    [fillPath closePath];

    UIColor *strokeColor = [UIColor blackColor];
    [strokeColor setStroke];

    UIColor *fillColor = [UIColor whiteColor];
    [fillColor setFill];

    [fillPath setLineWidth:4.0];
    [fillPath stroke];
    [fillPath fill];

}

@end
