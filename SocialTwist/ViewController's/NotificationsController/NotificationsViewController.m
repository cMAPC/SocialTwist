//
//  NotificationsViewController.m
//  SocialTwist
//
//  Created by Marcel  on 6/8/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController () {
    NSMutableArray* requestIdArray;
    NSMutableArray* userIdArray;
    NSMutableArray* userContentArray;
}

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableWithCustomCell];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:120];
//    userIdArray = [[NSMutableArray alloc] init];
    
    [[RequestManager sharedManager] getFriendsRequestOnSuccess:^(id responseObject) {
                NSLog(@"response object get friend : %@", responseObject);
//        userIdArray = (NSMutableArray *)[responseObject valueForKey:@"sender_id"];
        userIdArray = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"sender_id"]];
        requestIdArray = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"id"]];
//        userId = [[responseObject objectAtIndex:0] valueForKey:@"sender_id"];
        [self.tableView reloadData];
        
        
    } fail:^(NSError *error, NSInteger statusCode) {
        
    }];
    
    
    
    [[RequestManager sharedManager] getFriendsOnSuccess:^(id responseObject) {
        NSLog(@"Friend list : %@", responseObject);
    } fail:^(NSError *error, NSInteger statusCode) {
        
    }];
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendRequestCell" bundle:nil] forCellReuseIdentifier:@"FriendRequestCell"];
}

-(void)confirmRequestAction:(UIButton *)sender {
    NSLog(@"este");
    NSLog(@"sender tag %@", userIdArray[sender.tag]);
    [[RequestManager sharedManager] acceptUserFriendRequestWithId:requestIdArray[sender.tag]
                                                          success:^(id responseObject) {
                                                              NSLog(@"Accept friend response : %@", responseObject);
                                                              
                                                              [self.tableView beginUpdates];
                                                              [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:YES];
                                                              [userIdArray removeObjectAtIndex:sender.tag];
                                                              [requestIdArray removeObjectAtIndex:sender.tag];
                                                              [self.tableView endUpdates];
                                                              
                                                          } fail:^(NSError *error, NSInteger statusCode) {
                                                              
                                                          }];
    
    
 
}

-(void)rejectRequestAction:(UIButton *)sender {
    [[RequestManager sharedManager] rejectFriendRequestWithId:requestIdArray[sender.tag]
                                                      success:^(id responseObject) {
                                                          NSLog(@"Reject friend response : %@", responseObject);
                                                          
                                                          [self.tableView beginUpdates];
                                                          [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:YES];
                                                          [userIdArray removeObjectAtIndex:sender.tag];
                                                          [requestIdArray removeObjectAtIndex:sender.tag];
                                                          [self.tableView endUpdates];
                                                      } fail:^(NSError *error, NSInteger statusCode) {
                                                          
                                                      }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userIdArray count];//[responesObject count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendRequestCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
    
    cell.name.text = [NSString stringWithFormat:@"Friend request from id %@", userIdArray[indexPath.row]];
    
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


//    userContentArray = [[NSMutableArray alloc] init];
//    
//    for (NSString* userId in userIdArray) {
//        [[RequestManager sharedManager] getUserWithId:userId
//                                              success:^(id responseObject) {
//                                                  
//                                                  SearchContent* obj = [[SearchContent alloc] init];
//                                                  obj.userId = [[responseObject valueForKey:@"id"] integerValue];
//                                                  obj.firstName = [responseObject valueForKey:@"first_name"];
//                                                  obj.lastName = [responseObject valueForKey:@"last_name"];
//                                                  obj.sex = [responseObject valueForKey:@"sex"];
//                                                  [userContentArray addObject:obj];
//                                                  
//                                                  NSLog(@"ARRAY %ld", (long)[userContentArray count]);
//                                                  
//                                                  
//                                                  UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//                                                  [cell.textLabel setText:[NSString stringWithFormat:@"%@", [userContentArray[0] valueForKey:@"firstName"]]];
//                                                  
//                                                  [self.tableView reloadData];
//                                                  
//                                              } fail:^(NSError *error, NSInteger statusCode) {
//                                                  
//                                              }];
//    }
    
    [[RequestManager sharedManager] getFriendsOnSuccess:^(id responseObject) {
        NSLog(@"Friend list : %@", responseObject);
    } fail:^(NSError *error, NSInteger statusCode) {
        
    }];
}

@end
