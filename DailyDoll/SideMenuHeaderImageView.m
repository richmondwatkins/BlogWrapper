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

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"logo.png"]; //Add the file name

        NSData *pngData = [NSData dataWithContentsOfFile:filePath];

        self.image = [UIImage imageWithData:pngData];

        self.frame = CGRectMake(0, 0, self.image.size.width/2, self.image.size.height/2);

    }

    return self;
}
@end
