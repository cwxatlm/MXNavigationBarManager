//
//  MenuTableViewController.m
//  MXBarManagerDemo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 desn. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MXNavigationBarManager.h"
#import "GradientTableViewController.h"
#import "TranslateTableViewController.h"
#import "MutationTableViewController.h"
#import "ReversalTableViewController.h"

static NSString *const menuCellIdentifer = @"menuCellIdentifer";

@interface MenuTableViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation MenuTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [MXNavigationBarManager reStoreWithFullStatus];
    self.tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Menu";
    _titles = @[@"全透明导航栏",
                @"渐变导航栏",
                @"突变导航栏",
                @"颜色反转导航栏"];
    _viewControllers = @[[TranslateTableViewController class],
                         [GradientTableViewController class],
                         [MutationTableViewController class],
                         [ReversalTableViewController class]];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:menuCellIdentifer];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifer
                                                            forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[_viewControllers[indexPath.row] new] animated:YES];
}

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
