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
#import "SideMenuTableSectionHeader.h"
#import "SideMenuTableSectionLabel.h"
#import "APIManager.h"
#import "AccessoryPagesView.h"
#import "NotificationViewController.h"

#import "UIView+Additions.h"

@interface SideMenuViewController () <UITableViewDataSource, UITableViewDelegate, AccessoryPageProtocol>

@property NSMutableArray *dataSource;
@property SideMenuTableView *tableView;
@property UIImageView *headerImageView;
@property CGRect cachedImageViewSize;
@property SideMenuTableHeaderView *headerView;
@property CGPoint imageViewCenter;
@property UIButton *aboutButton;
@property AccessoryPagesView *accessoryPageView;
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

    [self.headerView addSubview:self.aboutButton];


    int notifButtonPadding = 4;
    self.notificationButton = [[UIButton alloc] initWithFrame:CGRectMake((viewControllerWidth - accessoryButtonSize.width) - notifButtonPadding,
                                                                         kTopButtonPadding,
                                                                         accessoryButtonSize.width,
                                                                         accessoryButtonSize.height)];

    [self.notificationButton setImage:[UIImage imageNamed:@"notification"]
                             forState:UIControlStateNormal];

    [self.notificationButton addTarget:self action:@selector(displayNotifications:)
                      forControlEvents:UIControlEventTouchUpInside];

    [self.headerView addSubview:self.notificationButton];

}

- (void)displayAboutPagePopOut {

    self.accessoryPageView = [[AccessoryPagesView alloc] initWithFrameAndButtons:self.view.frame];

    self.accessoryPageView.delegate = self;

    [self.view addSubview:self.accessoryPageView];

    [self.accessoryPageView animateOnToScreen:self.view.frame];
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

    return ((NSMutableArray *)self.dataSource[section][1]).count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SideMenuTableSectionHeader *view = [[SideMenuTableSectionHeader alloc] initWithParentFrame:self.view.frame andMenuItem:self.dataSource[section][0]];

    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [self.dataSource[section][0] valueForKey:@"title"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[SideMenuTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                            reuseIdentifier: @"cell"];
    }

    MenuItem *menuItem = ((NSMutableArray*) self.dataSource[indexPath.section])[1][indexPath.row];

    [cell addTextToMenu: menuItem];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MenuItem *menuItem = ((NSMutableArray*) self.dataSource[indexPath.section])[1][indexPath.row];
    
    NSMutableArray *menuItemArray = ((NSMutableArray*) self.dataSource[indexPath.section])[1];
    
    if (menuItem.children.count > 0) {
        if (menuItem.isExpanded.boolValue) {
            [self collapseCellsFromIndexOf:menuItem indexPath:indexPath tableView:tableView itemArray:menuItemArray];
        } else {
            [self expandCellsFromIndexOf:menuItem tableView:tableView indexPath:indexPath itemArray:menuItemArray];
        }
    } else {
        
        [self.delegate selectedSideMenuItem:menuItem.url];
        
        [self closeDrawController];
    }

}

- (void)expandCellsFromIndexOf:(MenuItem *)menuItem tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath itemArray:(NSMutableArray *)menuItems
{
    int i = 0;
    
    for (MenuItem *childItem in menuItem.children.allObjects) {
        [menuItems insertObject:childItem atIndex:indexPath.row+i+1];
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
                     withRowAnimation:UITableViewRowAnimationMiddle];
    
    menuItem.isExpanded = [NSNumber numberWithBool:YES];

    NSArray *sectionArray = self.dataSource[indexPath.section];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sectionArray.count + menuItems.count - 3 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:true];
}

- (void)collapseCellsFromIndexOf:(MenuItem *)menuItem indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView itemArray:(NSMutableArray *)menuItems
{
    // Find the number of childrens opened under the parent recursively as there can be expanded children also
    int collapseCol = (int) menuItem.children.count;
    
    // Find the range from the parent index and the length to be removed.
    NSRange collapseRange = NSMakeRange(indexPath.row + 1, collapseCol);
    // Remove all the objects in that range from the main array so that number of rows are maintained properly
    [menuItems removeObjectsInRange:collapseRange];
    
    // Create index paths for the number of rows to be removed
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < collapseRange.length; i++) {
        
        [indexPaths addObject:[NSIndexPath indexPathForRow:collapseRange.location + i inSection:indexPath.section]];
    }

    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationTop];
    
      menuItem.isExpanded = [NSNumber numberWithBool:NO];    
}

//TODO resize based on view height down to certain point then use min height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return (self.tableView.frame.size.height / 4) / self.dataSource.count;
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
