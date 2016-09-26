//
//  ReversalTableViewController.m
//  MXBarManagerDemo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 desn. All rights reserved.
//

#import "ReversalTableViewController.h"
#import "MXNavigationBarManager.h"

#define SCREEN_RECT [UIScreen mainScreen].bounds
static NSString *const kBackCellIdentifer = @"kBackCellIdentifer";
static const CGFloat headerImageHeight = 260.0f;

@interface ReversalTableViewController ()

@end

@implementation ReversalTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    
    //optional
    [MXNavigationBarManager setReversal:NO];
    [MXNavigationBarManager setContinues:YES];
    [MXNavigationBarManager reStoreToSystemNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseData];
    [self initBarManager];
}

- (void)initBarManager {
    
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1]];
    [MXNavigationBarManager setTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [MXNavigationBarManager setFullAlphaTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
    [MXNavigationBarManager setContinues:NO];
    
    //if you want the opposite visual, set reversal = YES
    [MXNavigationBarManager setReversal:YES];
    
}

- (void)initBaseData {
    self.title = @"长草颜文字";
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kBackCellIdentifer];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(SCREEN_RECT), headerImageHeight)];
    headerImageView.image = [UIImage imageNamed:@"headerImage"];
    self.tableView.tableHeaderView = headerImageView;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reversal" style:UIBarButtonItemStylePlain target:self action:@selector(mutation)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)mutation {
    
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBackCellIdentifer forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
