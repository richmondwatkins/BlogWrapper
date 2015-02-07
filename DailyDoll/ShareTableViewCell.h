//
//  ShareTableViewCell.h
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTableViewCell : UITableViewCell

typedef enum socialShareOptions
{
    FACEBOOK,
    PINTREST,
    TWITTER,
    INSTAGRAM,
    GOOGLEPLUS

} SocialShare;

- (void)addShareButtonAndAdjustFrame:(CGRect)parentFrame withCellObject:(NSDictionary *)object;

@end
