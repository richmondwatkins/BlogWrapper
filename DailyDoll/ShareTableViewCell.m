//
//  ShareTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "SocialItem.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addShareButtonAndAdjustFrame:(CGRect)parentFrame withCellObject:(SocialItem *)object {

    self.frame = CGRectMake(0, 0, parentFrame.size.width, self.frame.size.height);

    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-main",[object valueForKey:@"image"]]]];

    cellImageView.frame = CGRectMake(0, 0, cellImageView.image.size.width, cellImageView.image.size.height);

    [self addSubview:cellImageView];

    [cellImageView setCenter:CGPointMake(self.frame.size.width / 2,
                                         self.frame.size.height / 2)];

}

@end
