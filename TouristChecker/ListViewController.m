//
//  ListViewController.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "ListViewController.h"
#import "MapDataTableViewCell.h"
#import <UIScrollView+EmptyDataSet.h>

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // if no point on map, show description
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DZN EmptyDataSet Source

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Please Obtain Some Data";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Long Press on Map or Allow Location Access will help you get place datas.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor grayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"Back";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZN EmptyDataSet Delegate

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const REUSE_MAP_CELL = @"MAP_DATA_CELL";
    MapDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_MAP_CELL forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setupCellView:)]) {
        [cell performSelector:@selector(setupCellView:) withObject:[self.viewModel.dataArray objectAtIndex:indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(listController:selectMapModel:)]) {
        [self.delegate listController:self selectMapModel:[self.viewModel.dataArray objectAtIndex:indexPath.row]];
    }
}

@end
