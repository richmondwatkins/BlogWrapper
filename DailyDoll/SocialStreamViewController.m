//
//  SocialStreamViewController.m
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialStreamViewController.h"
#import "APIManager.h"
#import "SocialStreamViewModel.h"
#import "FacebookTableViewCell.h"

@interface SocialStreamViewController () <SocialStreamProtocol, UITableViewDataSource, UITableViewDelegate>

@property SocialStreamViewModel *viewModel;
@property UITableView *tableView;

@end

@implementation SocialStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.viewModel = [[SocialStreamViewModel alloc] init];
    self.viewModel.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SocialCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.frame;
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.socialItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *socialItem = self.viewModel.socialItems[indexPath.row];
    
    UITableViewCell *cell;
    
    if ([socialItem[@"isFacebook"] boolValue]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FacebookCell"];
        
        if (cell == nil) {
            cell = [[FacebookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FacebookCell"];
            
            cell.backgroundColor = [UIColor blueColor];
        }

        cell.textLabel.text = socialItem[@"message"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialCell"];
        }
        
         cell.textLabel.text = socialItem[@"message"];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.socialItems.count > 0) {
        NSDictionary *socialItem = self.viewModel.socialItems[indexPath.row];
        
        if ([socialItem[@"isFacebook"] boolValue]) {
            if (socialItem[@"post-image"] != nil) {                
                return 200;
            }
        }
    }
    
    return 30;
}

@end
