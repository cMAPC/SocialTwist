//
//  FriendListViewController.m
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "FriendListViewController.h"

@interface FriendListViewController () {
    NSMutableArray* friendContentArray;
}

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableWithCustomCell];
    [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setEstimatedRowHeight:200];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    [[RequestManager sharedManager] getFriendsOnSuccess:^(id responseObject) {
        friendContentArray = responseObject;
        [self.tableView reloadData];
    } fail:^(NSError *error, NSInteger statusCode) {
        
    }];
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCell"];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendContentArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",
                           [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                           [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"lastName"]
                           ];
    
    cell.ageLabel.text = [NSString stringWithFormat:@"%@, %@",
                          [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"userID"],
                          [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"location"]
                          ];
    
    return cell;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction* deleteAction;
    
    deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                      title:@"Unfriend"
                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                        
                                                        [[RequestManager sharedManager]
                                                         deleteFriendWithID:[[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"userID"]
                                                         success:^(id responseObject) {
                                                             NSLog(@"Delete friend response %@", responseObject);
                                                         }
                                                         fail:nil];
                                                        
                                                        [friendContentArray removeObjectAtIndex:indexPath.row];
                                                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                         withRowAnimation:YES];
                                                        [tableView reloadData];
                                                    }];
    return @[deleteAction];
}

@end
