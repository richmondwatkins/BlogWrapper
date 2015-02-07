//
//  ShareTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareTableViewCell.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addShareButton {

    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];

    [self addSubview:cellImageView];

    [cellImageView setCenter:CGPointMake(self.frame.size.width / 2,
                                         self.frame.size.height / 2)];
}

@end
