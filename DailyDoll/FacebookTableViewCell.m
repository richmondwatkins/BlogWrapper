//
//  FacebookTableViewCell.m
//  DailyDoll
//
//  Created by Richmond Watkins on 6/13/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "FacebookTableViewCell.h"

@interface FacebookTableViewCell ()

@property UILabel *label;

@end

@implementation FacebookTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSLog(@"init");
    
    return self;
}

@end
