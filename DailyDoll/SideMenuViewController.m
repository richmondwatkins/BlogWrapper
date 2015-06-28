//
//  SideMenuViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuViewController.h"
#import "CenterViewController.h"
#import <MMDrawerController.h>
#import "SideMenuTableViewCell.h"
#import "SideMenuTableView.h"
#import "SideMenuTableHeaderView.h"
#import "SideMenuHeaderImageView.h"
#import "APIManager.h"
#import "NotificationViewController.h"

#import "UIView+Additions.h"

@interface SideMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *dataSource;
@property SideMenuTableView *tableView;
@property UIImageView *headerImageView;
@property CGRect cachedImageViewSize;
@property SideMenuTableHeaderView *headerView;
@property CGPoint imageViewCenter;
@property UIButton *aboutButton;
@property UIButton *notificationButton;

@end

int const kTopButtonPadding = 4;

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[SideMenuTableView alloc] initWithFrame:CGRectMake(0,
                                                                         self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height + 20,
                                                                         [self returnWidthForMenuViewController],
                                                                         self.view.frame.size.height)
                                                        style:UITableViewStylePlain];

    [self.tableView removeInsetsAndStyle];

    [self setUpHeaderView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];

    self.dataSource = [[APIManager sharedManager] fetchMenuItemsAndHeaders];

    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMenu)
                                                 name:@"coreDataUpdated" object:nil];
}

- (void)updateMenu {
    self.dataSource = [[APIManager sharedManager] fetchMenuItemsAndHeaders];
    
    [self.tableView reloadData];
}

-(void)viewDidLayoutSubviews {

    CGPoint headerCenter = CGPointMake(self.tableView.frame.size.width / 2,
                                       self.headerView.frame.size.height / 2);

    [self.headerImageView setCenter:headerCenter];

    self.imageViewCenter = headerCenter;

    self.cachedImageViewSize = self.headerImageView.frame;
}

- (void)setUpHeaderView {

    int viewControllerWidth = [self returnWidthForMenuViewController];

    self.headerImageView = [[SideMenuHeaderImageView alloc] initWithParentFrame:self.view.frame
                                                                 andMenuVCWidth:viewControllerWidth + 20];

    self.headerView = [[SideMenuTableHeaderView alloc] initWithFrame:self.view.frame
                                                           menuInset:viewControllerWidth
                                                        andImageView:self.headerImageView.frame];

    [self.headerView addSubview:self.headerImageView];

    [self.headerImageView setCenter:CGPointMake(self.view.frame.size.width / 2, self.headerView.frame.size.height / 2)];


    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(displayHomePage:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.headerView addGestureRecognizer:tapGesture];

    self.tableView.tableHeaderView = self.headerView;

    CGSize accessoryButtonSize = CGSizeMake(30, 30);

    self.aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(kTopButtonPadding,
                                                                  kTopButtonPadding,
                                                                  accessoryButtonSize.width,
                                                                  accessoryButtonSize.height)];

    [self.aboutButton setImage:[UIImage imageNamed:@"about"]
                      forState:UIControlStateNormal];

    [self.aboutButton addTarget:self action:@selector(displayAboutPagePopOut)
               forControlEvents:UIControlEventTouchUpInside];

//    [self.headerView addSubview:self.aboutButton];


    int notifButtonPadding = 4;
    self.notificationButton = [[UIButton alloc] initWithFrame:CGRectMake((viewControllerWidth - accessoryButtonSize.width) - notifButtonPadding,
                                                                         kTopButtonPadding,
                                                                         accessoryButtonSize.width,
                                                                         accessoryButtonSize.height)];

    [self.notificationButton setImage:[UIImage imageNamed:@"notification"]
                             forState:UIControlStateNormal];

    [self.notificationButton addTarget:self action:@selector(displayNotifications:)
                      forControlEvents:UIControlEventTouchUpInside];

//    [self.headerView addSubview:self.notificationButton];

}

- (void)displayNotifications:(UIButton *)sender {

    CGFloat popUpWidth = self.view.width * 0.8;

    NotificationViewController *notifVC = [[NotificationViewController alloc] initWithStyleAndFrame:CGRectMake(sender.center.x - popUpWidth, sender.height + kTopButtonPadding, self.view.width * 0.8, self.view.height * 0.4) andParentWidth:self.view.width];

    [self addChildViewController:notifVC];
    [self.view addSubview:notifVC.view];


    [notifVC didMoveToParentViewController:self];
}


#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[SideMenuTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                            reuseIdentifier: @"cell"];
    }

    MenuItem *menuItem = self.dataSource[indexPath.row];

    [cell configureCell: menuItem];

    return cell;
}

//TODO resize based on view height down to certain point then use min height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuItem *menuTime = self.dataSource[indexPath.row];
    
    if (menuTime.isHeader.boolValue) {
        return 30;
    }
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MenuItem *menuItem = self.dataSource[indexPath.row];
    
    if (menuItem.children.count > 0) {
        if (menuItem.isExpanded.boolValue) {
            menuItem.isExpanded = [NSNumber numberWithBool:NO];
            [self collapseCellsFromIndexOf:menuItem indexPath:indexPath tableView:tableView];
        } else {
            menuItem.isExpanded = [NSNumber numberWithBool:YES];
            [self expandCellsFromIndexOf:menuItem tableView:tableView indexPath:indexPath];
        }
        
        SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell flipArrowOrientation:menuItem];
        
        //Fixes cell seperator dissapearing on animation (iOS bug)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        
        [self.delegate selectedSideMenuItem:menuItem.url];
        
        [self closeDrawController];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
     MenuItem *menuItem = self.dataSource[indexPath.row];
    
    if (menuItem.isHeader.boolValue) {
        return NO;
    }
    
    return YES;
}

- (void)expandCellsFromIndexOf:(MenuItem *)menuItem tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    int i = 0;
    
    for (MenuItem *childItem in menuItem.children.allObjects) {
        
        [self.dataSource insertObject:childItem atIndex:indexPath.row+i+1];
        
        i++;
    }
  
    // Find the range for insertion
    NSRange expandedRange = NSMakeRange(indexPath.row, menuItem.children.count);
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    // Create index paths for the range
    for (int i = 0; i < expandedRange.length; i++) {
        
        [indexPaths addObject:[NSIndexPath indexPathForRow:expandedRange.location+i+1 inSection:indexPath.section]];
    }
    
    // Insert the rows
    [tableView insertRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (void)collapseCellsFromIndexOf:(MenuItem *)menuItem indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    // Find the number of childrens opened under the parent recursively as there can be expanded children also
    int collapseCol = (int) menuItem.children.count;
    
    // Find the range from the parent index and the length to be removed.
    NSRange collapseRange = NSMakeRange(indexPath.row + 1, collapseCol);
    // Remove all the objects in that range from the main array so that number of rows are maintained properly
    [self.dataSource removeObjectsInRange:collapseRange];
    
    // Create index paths for the number of rows to be removed
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < collapseRange.length; i++) {
        
        [indexPaths addObject:[NSIndexPath indexPathForRow:collapseRange.location + i inSection:indexPath.section]];
    }

    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat y = -scrollView.contentOffset.y;
    
    if (y > 0) {

        self.headerImageView.frame = CGRectMake(0, self.cachedImageViewSize.origin.y,
                                                self.cachedImageViewSize.size.width+y,
                                                self.cachedImageViewSize.size.height+y);

        self.headerImageView.center = CGPointMake(self.imageViewCenter.x,
                                                  self.imageViewCenter.y - (y/2));

        [self.aboutButton holdPositionDuringScroll:-y withOriginalY:kTopButtonPadding];

        [self.notificationButton holdPositionDuringScroll:-y withOriginalY:kTopButtonPadding];
    }
}

- (void)displayHomePage:(id)sender {

    NSString *homeUrl = [[APIManager sharedManager] fetchmetaDataVariables:kURLString];

    [self.delegate selectedSideMenuItem:homeUrl];

    [self closeDrawController];
}

- (void)showAccessoryPage:(NSString *)urlString {

    [self.delegate selectedSideMenuItem:urlString];

    [self closeDrawController];
}

- (int)returnWidthForMenuViewController {

    return [[UIScreen mainScreen] bounds].size.width - [[UIScreen mainScreen] bounds].size.width * 0.2;
}

- (void)closeDrawController {

    MMDrawerController *drawController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    UINavigationController *navVC = (UINavigationController *)drawController.centerViewController;

    CenterViewController *centerVC = [navVC.viewControllers firstObject];

    centerVC.isFromSideMenu = YES;

    [drawController closeDrawerAnimated:YES completion:nil];
}

@end
