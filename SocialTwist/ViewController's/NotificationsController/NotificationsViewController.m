//
//  NotificationsViewController.m
//  SocialTwist
//
//  Created by Marcel  on 6/8/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController () {
    NSMutableArray* requestIDArray;
    NSMutableArray* userIDArray;
    NSMutableArray* userContentArray;
}

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableWithCustomCell];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:120];
    
    requestIDArray = [[[RequestManager sharedManager] getFriendRequests] valueForKey:@"id"];
    userIDArray = [[[RequestManager sharedManager] getFriendRequests] valueForKey:@"sender_id"];
    userContentArray = [[RequestManager sharedManager] getUsersWithID:userIDArray];
    
    NSLog(@"Request array - %@", userIDArray);
    NSLog(@"User content - %@", userContentArray);
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendRequestCell" bundle:nil] forCellReuseIdentifier:@"FriendRequestCell"];
}

-(void)confirmRequestAction:(UIButton *)sender {
    [[RequestManager sharedManager] acceptUserFriendRequestWithID:requestIDArray[sender.tag]
                                                          success:^(id responseObject) {
                                                              NSLog(@"Accept friend response : %@", responseObject);
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self.tableView beginUpdates];
                                                              [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:YES];
                                                              [userContentArray removeObjectAtIndex:sender.tag];
                                                              [self.tableView endUpdates];
                                                              });
                                                              
                                                          } fail:^(NSError *error, NSInteger statusCode) {
                                                              
                                                          }];
    
    
 
}

-(void)rejectRequestAction:(UIButton *)sender {
    [[RequestManager sharedManager] rejectFriendRequestWithID:requestIDArray[sender.tag]
                                                      success:^(id responseObject) {
                                                          NSLog(@"Reject friend response : %@", responseObject);
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self.tableView beginUpdates];
                                                              [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:YES];
                                                              [userContentArray removeObjectAtIndex:sender.tag];
                                                              [self.tableView endUpdates];
                                                          });
                                                         
                                                      } fail:^(NSError *error, NSInteger statusCode) {
                                                          
                                                      }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userContentArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendRequestCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@",
                      [[userContentArray objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                      [[userContentArray objectAtIndex:indexPath.row] valueForKey:@"lastName"]
                      ];
    
    cell.confirmRequestButton.tag = indexPath.row;
    cell.rejectRequestButton.tag = indexPath.row;
    
    [cell.confirmRequestButton addTarget:self action:@selector(confirmRequestAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectRequestButton addTarget:self action:@selector(rejectRequestAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    /*
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
 
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
    }
    
    [cell.textLabel setText: [NSString stringWithFormat:@"Friend request from id %@", userIdArray[indexPath.row] ]
     ];
    
//    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [userContentArray[indexPath.row] valueForKey:@"firstName"]]];
    
    return cell;
    */
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [[RequestManager sharedManager] getFriendsOnSuccess:^(id responseObject) {
//        NSLog(@"Friend list : %@", responseObject);
//        
//    } fail:^(NSError *error, NSInteger statusCode) {
//        
//    }];
}

@end
