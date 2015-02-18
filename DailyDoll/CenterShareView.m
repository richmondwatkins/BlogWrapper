//
//  CenterShareView.m
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterShareView.h"
#import "ProjectSettings.h"
#import "SocialItem.h"
#import "SocialShareMethods.h"

@import Social;

@interface CenterShareView ()

@property CGPoint originalCenter;

@property CGFloat maxTopYPostition;

@property Pinterest *pinterest;

@end

CGFloat const kButtonHeightAndWidth = 40;

@implementation CenterShareView

- (instancetype)initWithFrameAndStyle:(CGRect)parentFrame {

    if (self = [super init]) {

        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];

        CGFloat height = parentFrame.size.height * 0.1;

        self.frame = CGRectMake(0, 0, parentFrame.size.width, height);

        self.originalCenter = CGPointMake(parentFrame.size.width / 2, parentFrame.size.height + height / 2);

        [self setCenter:self.originalCenter];

        self.layer.cornerRadius = 5;

        self.maxTopYPostition = self.originalCenter.y - self.frame.size.height;

        [self addShareButtonsToView];

    }

    return self;
}

- (void)addShareButtonsToView {

    NSArray *socialShareItems = [[ProjectSettings sharedManager] shareItems];

    CGFloat buttonPadding = [self calculateButtonPadding:socialShareItems.count];

    for (SocialItem *socialItem in socialShareItems) {

        CGSize buttonSize = CGSizeMake(kButtonHeightAndWidth, kButtonHeightAndWidth);

        UIButton *socialButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];

        UIImage *btnImage = [UIImage imageNamed:socialItem.image];

        [socialButton setImage:btnImage forState:UIControlStateNormal];

        [self addShareMethodToItem:socialButton withId:[socialItem.id intValue]];

        UIView *lastSubView = [[self subviews] lastObject];

        [self addSubview:socialButton];

        if (lastSubView) {

            [socialButton setCenter:CGPointMake(lastSubView.center.x + (buttonPadding+ kButtonHeightAndWidth/2), self.frame.size.height / 2)];
        }else {

            [socialButton setCenter:CGPointMake(buttonPadding + (kButtonHeightAndWidth/2), self.frame.size.height / 2)];
        }

    }

}


- (void)addShareMethodToItem:(UIButton *)shareButton withId:(int)socialId {

    switch (socialId) {
        case 0:

            [shareButton addTarget:self action:@selector(facebookShareDelegate:) forControlEvents:UIControlEventTouchUpInside];
        break;

        case 1:

            [shareButton addTarget:self action:@selector(pinIt:) forControlEvents:UIControlEventTouchUpInside];
        break;

        case 2:

            [shareButton addTarget:self action:@selector(tweet:) forControlEvents:UIControlEventTouchUpInside];
        break;

        case 3:

        break;

        case 4:

            [shareButton addTarget:self action:@selector(googlePlusShare:) forControlEvents:UIControlEventTouchUpInside];
        break;

        default:
            break;
    }


}

- (void)facebookShareDelegate:(UIButton *)button {

    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];

    params.link = [self.delegate returnCurrentURL];

    NSString *accountPage = [[ProjectSettings sharedManager] fetchSocialItem:FACEBOOK withProperty:kURLString];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToFaceBookWithURL:params];

    if (!didShare) {

        [self.delegate socialWebView:[NSURL URLWithString:accountPage]];
    }

    
}

- (void)pinIt:(UIButton *)button {

    //TODO create algorithm to pull image off of page
    NSURL *imageURL = [NSURL URLWithString:@"http://placekitten.com/g/200/300"];
    NSURL *sourceURL = [self.delegate returnCurrentURL];

    NSString *accountPage = [[ProjectSettings sharedManager] fetchSocialItem:PINTEREST withProperty:kURLString];

    BOOL didShare = [[SocialShareMethods sharedManager] pinToPinterest:imageURL andSource:sourceURL];

    if (!didShare) {

        [self.delegate socialWebView:[NSURL URLWithString:accountPage]];
    }

}

- (void)tweet:(UIButton *)button {

    NSString *currentPage = [[self.delegate returnCurrentURL] absoluteString];

    NSString *blogName = [[ProjectSettings sharedManager] metaDataVariables:kSiteName];

//    NSString *accountPage = [[ProjectSettings sharedManager] fetchSocialItem:TWIITER withProperty:kURLString];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToTwitter:[NSString stringWithFormat:@"%@ - %@", blogName, currentPage]];

    if (!didShare) {

        [self.delegate oAuthSetUpDelegate:TWIITER];
//        [self.delegate socialWebView:[NSURL URLWithString:accountPage]];
    }

}

- (void) googlePlusShare:(UIButton *)button {


    NSURL *sourceURL = [NSURL URLWithString:[[ProjectSettings sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kURLString]];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToGooglePlus:sourceURL.absoluteString];

    if (!didShare) {

        [self.delegate oAuthSetUpDelegate:GOOGLEPLUS];
    }
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

@end
