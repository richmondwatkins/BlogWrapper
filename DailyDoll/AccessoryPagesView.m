//
//  AccessoryPagesView.m
//  DailyDoll
//
//  Created by Richmond on 2/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "AccessoryPagesView.h"
#import "ProjectSettings.h"
#import "AccessoryPage.h"
#import "SocialShareMethods.h"

@interface AccessoryPagesView ()

@property NSArray *accessoryPages;

@property CGPoint originalCenter;

@end

@implementation AccessoryPagesView

CGFloat const kAccessoryButtonPadding = 20;
CGFloat const kAccessoryButtonHeight = 40;

- (instancetype)initWithFrameAndButtons:(CGRect)parentFrame {

    if (self = [super init]) {

        self.frame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);

        self.alpha = 0;

        self.popUp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.9, parentFrame.size.height / 2)];

        [self.popUp setCenter:CGPointMake(-parentFrame.size.width / 2, parentFrame.size.height / 2)];

        self.popUp.layer.cornerRadius = 5;
        self.popUp.layer.shadowOpacity = 0.8;
        self.popUp.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        self.popUp.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.popUp];

        [self addButtons];

        [self addContactButton];

        self.popUp.frame = [self adjustPopUpFrame]; //adjusts for buttons

        self.originalCenter = self.popUp.center;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateOffOfScreen)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];

    }

    return self;
}

- (void)addButtons {

    self.accessoryPages = [[ProjectSettings sharedManager] fetchMetaDataAccessoryPages];

    for (int i = 0; i < self.accessoryPages.count; i++) {

        UIButton *accButton = [[UIButton alloc] init];

        AccessoryPage *accessoryPage = self.accessoryPages[i];

        [accButton setTitle:accessoryPage.title forState:UIControlStateNormal];

        [accButton addTarget:self action:@selector(displayAccessoryPage:) forControlEvents:UIControlEventTouchUpInside];

        accButton.tag = (NSInteger)i;

        [self setButtonsPositionInViewAndStyle:accButton];

    }

}

- (void)addContactButton {

    UIButton *contactButton = [[UIButton alloc] init];

    [contactButton setTitle:@"Contact" forState:UIControlStateNormal];

    [contactButton addTarget:self action:@selector(displayContactView) forControlEvents:UIControlEventTouchUpInside];

    [self setButtonsPositionInViewAndStyle:contactButton];
}

- (void)setButtonsPositionInViewAndStyle:(UIButton *)button {

    button.frame = CGRectMake(0, 0, self.popUp.frame.size.width * 0.9, kAccessoryButtonHeight);

    UIView *lastSubView = [[self.popUp subviews] lastObject];

    if (lastSubView) {

        [button setCenter:CGPointMake(self.popUp.frame.size.width / 2,
                                         lastSubView.center.y + button.frame.size.height + kAccessoryButtonPadding)];
    }else {

        [self setFirstButton:button withPopUp:self.popUp];
    }

    [button addTarget:self action:@selector(animateOffOfScreen) forControlEvents:UIControlEventTouchUpInside];

    button.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kPrimaryColor]];

    button.layer.cornerRadius = 3;

    [self.popUp addSubview:button];
}

- (void)displayContactView {

    NSString *email = [[ProjectSettings sharedManager] metaDataVariables:kEmail];

    NSString *blogTitle = [[ProjectSettings sharedManager] metaDataVariables:kBlogName];

    [[SocialShareMethods sharedManager] shareViaEmail:@{@"subject": blogTitle, @"recipient": email}];
}

- (void)setFirstButton:(UIButton *)button withPopUp:(UIView *)popUp {

    [button setCenter:CGPointMake(popUp.frame.size.width / 2,
                                  kAccessoryButtonPadding + kAccessoryButtonHeight/2)];
}

- (void)displayAccessoryPage:(UIButton *)button {

    AccessoryPage *accPage = [self.accessoryPages objectAtIndex:(int)button.tag];

    [self.delegate showAccessoryPage:accPage.urlString];
}

- (CGRect)adjustPopUpFrame {

    int subViewCount = (int) [self.popUp subviews].count;

    return  CGRectMake(self.popUp.frame.origin.x,
                                  self.popUp.frame.origin.y,
                                  self.popUp.frame.size.width, (kAccessoryButtonHeight * subViewCount) + (kAccessoryButtonPadding * (subViewCount + 1) ) );
}

- (void)animateOnToScreen:(CGRect)parentFrame {

    [UIView animateWithDuration:0.3 animations:^{

        self.alpha = 1;

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

        [self.popUp setCenter:CGPointMake(parentFrame.size.width/2 , self.originalCenter.y)];
    }];
}

- (void)animateOffOfScreen {


    [UIView animateWithDuration:0.3 animations:^{

        self.alpha = 0;

        [self.popUp setCenter:self.originalCenter];

    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}


@end
