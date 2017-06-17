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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userContentArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendRequestCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",
                           [[userContentArray objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                           [[userContentArray objectAtIndex:indexPath.row] valueForKey:@"lastName"]
                           ];
    
    NSString* userImageURL = [[userContentArray objectAtIndex:indexPath.row] picture];
    [[DLImageLoader sharedInstance] imageFromUrl:userImageURL
                                       completed:^(NSError *error, UIImage *image) {
                                           [cell.pictureImageView setImage:image];
                                       }];

/* AFNetworking
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString* userImageURL = [[userContentArray objectAtIndex:indexPath.row] picture];
        UIImage* userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.pictureImageView setImage:userImage];
        });
    });
*/
 
    return cell;
}

#pragma mark - UITableViewDelegate
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction* reject = [UITableViewRowAction
                                    rowActionWithStyle:UITableViewRowActionStyleDestructive
                                    title:@"Reject"
                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                        [self rejectRequest:indexPath];
                                    }];
    
    UITableViewRowAction* confirm = [UITableViewRowAction
                                    rowActionWithStyle:UITableViewRowActionStyleNormal
                                    title:@"Confirm"
                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                        [self confirmRequest:indexPath];
                                    }];
    
    return @[reject, confirm];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Actions
-(void)confirmRequest:(NSIndexPath *)indexPath {
    [[RequestManager sharedManager] acceptUserFriendRequestWithID:requestIDArray[indexPath.row]
                                                          success:^(id responseObject) {
                                                              NSLog(@"Accept friend response : %@", responseObject);
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self.tableView beginUpdates];
                                                                  [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                        withRowAnimation:YES];
                                                                  [userContentArray removeObjectAtIndex:indexPath.row];
                                                                  [self.tableView endUpdates];
                                                              });
                                                              
                                                          } fail:^(NSError *error, NSInteger statusCode) {
                                                              
                                                          }];
    
    
    
}

-(void)rejectRequest:(NSIndexPath *)indexPath {
    [[RequestManager sharedManager] rejectFriendRequestWithID:requestIDArray[indexPath.row]
                                                      success:^(id responseObject) {
                                                          NSLog(@"Reject friend response : %@", responseObject);
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self.tableView beginUpdates];
                                                              [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                    withRowAnimation:YES];
                                                              [userContentArray removeObjectAtIndex:indexPath.row];
                                                              [self.tableView endUpdates];
                                                          });
                                                          
                                                      } fail:^(NSError *error, NSInteger statusCode) {
                                                          
                                                      }];
}
@end
