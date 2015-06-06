//
//  CenterShareView.m
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareViewSlider.h"
#import "APIManager.h"
#import "SocialItem.h"
#import "SocialShareMethods.h"

#import <QuartzCore/QuartzCore.h>

@import Social;

@interface ShareViewSlider ()

@property CGPoint originalCenter;

@property CGFloat maxTopYPostition;

@property Pinterest *pinterest;

@end

CGFloat const kButtonHeightAndWidth = 40;

@implementation ShareViewSlider

- (instancetype)initWithFrameAndStyle:(CGRect)parentFrame {
    //TODO move to detail view...use same social icons throughout. 
    if (self = [super init]) {

        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];

        CGFloat height = parentFrame.size.height * 0.1;

        self.frame = CGRectMake(0, 0, parentFrame.size.width, height);

        self.originalCenter = CGPointMake(parentFrame.size.width / 2, (parentFrame.size.height + height / 2));

        [self setCenter:self.originalCenter];

        self.layer.cornerRadius = 5;

        self.maxTopYPostition = self.originalCenter.y - self.frame.size.height;

        [self addShareButtonsToView];

        //TODO make this work in landscape
    }

    return self;
}

- (void)addShareButtonsToView {

    NSArray *socialShareItems = [[APIManager sharedManager] shareItemsWithoutInstagram];

    CGFloat buttonPadding = [self calculateButtonPadding:socialShareItems.count];

    for (SocialItem *socialItem in socialShareItems) {

        CGSize buttonSize = CGSizeMake(kButtonHeightAndWidth, kButtonHeightAndWidth);

        UIButton *socialButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];

        UIImage *btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-main",socialItem.image]];

        [socialButton setImage:btnImage forState:UIControlStateNormal];

        [self addShareMethodToItem:socialButton withId:[socialItem.platformId intValue]];

        UIView *lastSubView = [[self subviews] lastObject];

        [self addSubview:socialButton];

        if (lastSubView && ![lastSubView isKindOfClass:[UILabel class]]) {

            [socialButton setCenter:CGPointMake(lastSubView.center.x + (buttonPadding+ kButtonHeightAndWidth/2) , (self.frame.size.height / 2))];
        }else {

            [socialButton setCenter:CGPointMake(buttonPadding + (kButtonHeightAndWidth/2), (self.frame.size.height / 2))];
        }

    }

}


- (void)addShareMethodToItem:(UIButton *)shareButton withId:(int)socialId {

    switch (socialId) {
        case FACEBOOK:

            [shareButton addTarget:self action:@selector(facebookShareDelegate:) forControlEvents:UIControlEventTouchUpInside];
        break;

        case PINTEREST:

            [shareButton addTarget:self action:@selector(pinIt:) forControlEvents:UIControlEventTouchUpInside];
        break;

        case TWIITER:

            [shareButton addTarget:self action:@selector(tweet:) forControlEvents:UIControlEventTouchUpInside];
        break;

        case INSTAGRAM:
            //instagram
        break;

        case GOOGLEPLUS: {

            [shareButton addTarget:self action:@selector(googlePlusShare:) forControlEvents:UIControlEventTouchUpInside];

        }
        break;

        case EMAIL:

            [shareButton addTarget:self action:@selector(shareViaEmail:) forControlEvents:UIControlEventTouchUpInside];
            break;

        case SMS:

            [shareButton addTarget:self action:@selector(shareViaSMS:) forControlEvents:UIControlEventTouchUpInside];
            break;

        default:
            break;
    }

    [shareButton addTarget:self action:@selector(addSpinAnimation:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)facebookShareDelegate:(UIButton *)button {

    [self.delegate removeWindowViews];

    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];

    params.link = [self.delegate returnCurrentURL];

    NSString *accountPage = [[APIManager sharedManager] fetchSocialItem:FACEBOOK withProperty:kSocialAccountURL];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToFaceBookWithURL:params];

    if (!didShare) {

        [self.delegate socialWebView:[NSURL URLWithString:accountPage]];
    }
}

- (void)pinIt:(UIButton *)button {

    [self.delegate removeWindowViews];

    //TODO create algorithm to pull image off of page
    NSURL *imageURL = [NSURL URLWithString:@"http://placekitten.com/g/200/300"];
    NSURL *sourceURL = [self.delegate returnCurrentURL];

    NSString *accountPage = [[APIManager sharedManager] fetchSocialItem:PINTEREST withProperty:kSocialAccountURL];

    BOOL didShare = [[SocialShareMethods sharedManager] pinToPinterest:imageURL andSource:sourceURL];

    if (!didShare) {

        [self.delegate socialWebView:[NSURL URLWithString:accountPage]];
    }

}

- (void)tweet:(UIButton *)button {

    [self.delegate removeWindowViews];

    NSString *currentPage = [[self.delegate returnCurrentURL] absoluteString];

    NSString *blogName = [[APIManager sharedManager] fetchmetaDataVariables:kSiteName];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToTwitter:[NSString stringWithFormat:@"%@ - %@", blogName, currentPage]];

    if (!didShare) {

        [self.delegate oAuthSetUpDelegate:TWIITER];
    }

}

- (void) googlePlusShare:(UIButton *)button {

    [self.delegate removeWindowViews];

    NSURL *sourceURL = [NSURL URLWithString:[[APIManager sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kSocialAccountURL]];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToGooglePlus:sourceURL.absoluteString];

    if (!didShare) {

        [self.delegate oAuthSetUpDelegate:GOOGLEPLUS];
    }
}

- (void)shareViaEmail:(UIButton *)button {

    [self.delegate removeWindowViews];

    NSURL *sourceURL = [self.delegate returnCurrentURL];

    NSString *blogName = [[APIManager sharedManager] fetchmetaDataVariables:kBlogName];

    [[SocialShareMethods sharedManager] shareViaEmail:@{@"subject": blogName, @"message":sourceURL.absoluteString}];

}

- (void)shareViaSMS:(UIButton *)button {

    [self.delegate removeWindowViews];

    NSURL *sourceURL = [self.delegate returnCurrentURL];

    [[SocialShareMethods sharedManager] shareViaSMS:@{@"message":sourceURL.absoluteString}];
}


- (CGFloat)calculateButtonPadding:(NSInteger)socialItemCount {

    CGFloat totalArea = self.frame.size.width - ((socialItemCount+1) * kButtonHeightAndWidth);

    CGFloat tester = totalArea / (socialItemCount+1);

    return tester + kButtonHeightAndWidth/2;
}

- (void)animateOntoScreen {

    [UIView animateWithDuration:0.3 animations:^{

        [self setCenter:CGPointMake(self.originalCenter.x, self.maxTopYPostition)];
    }];
}

- (void)animateOffScreen{

    [UIView animateWithDuration:0.3 animations:^{

        [self setCenter:self.originalCenter];
    }];
}


- (void)slideUpOnDrag:(int)pixels {

    if (self.frame.origin.y >= self.maxTopYPostition - ((self.frame.size.height / 2) - 3)) {

        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - pixels, self.frame.size.width, self.frame.size.height);
    }
}

- (void)slideDownOnDrag:(int)pixels {

    if (self.frame.origin.y <= self.originalCenter.y) {

        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + pixels, self.frame.size.width, self.frame.size.height);
    }
}

- (void)addSpinAnimation:(UIButton *) button {

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0 * 1 * 5 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;

    [button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
