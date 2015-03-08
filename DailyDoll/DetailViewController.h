//
//  DetailViewController.h
//  DailyDoll
//
//  Created by Richmond on 3/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDViewController.h"
#import "BASocialShareViewController.h"

@interface DetailViewController : BASocialShareViewController

-(instancetype)initWithRequest:(NSURLRequest *)request;

@end
