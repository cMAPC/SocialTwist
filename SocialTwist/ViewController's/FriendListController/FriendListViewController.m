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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
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
    
    [cell.messageButton setTag:indexPath.row];
    [cell.messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",
                           [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                           [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"lastName"]
                           ];
    
    cell.ageLabel.text = [NSString stringWithFormat:@"%ld years, %@ %@",
                          [self getAgeFromDate:[[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"birthday"]],
                          [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"location"],
                          [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"userID"]
                          ];
    
    NSString* userImageURL = [[friendContentArray objectAtIndex:indexPath.row] picture];
    [[DLImageLoader sharedInstance] imageFromUrl:userImageURL
                                       completed:^(NSError *error, UIImage *image) {
                                           [cell.userImageView setImage:image];
                                       }];


/* AFNetworking
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString* userImageURL = [[friendContentArray objectAtIndex:indexPath.row] picture];
        UIImage* userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.userImageView setImage:userImage];
        });
    });
*/
    
    return cell;
}

#pragma mark - UITableView Delegate
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController* userProfileController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    
    [userProfileController setName:[NSString stringWithFormat:@"%@ %@",
                                    [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                                    [[friendContentArray objectAtIndex:indexPath.row] valueForKey:@"userID"]
                                    ]];
    
    [self.navigationController pushViewController:userProfileController animated:YES];
}
#pragma mark - Actions
-(void)sendMessage:(UIButton *)sender {
    NSLog(@"Message button pressed");
}

-(NSInteger)getAgeFromDate:(NSString *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* birthdayString = date;
    NSDate* birthday = [dateFormatter dateFromString:birthdayString];
    NSDate* currentDate = [NSDate date];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:currentDate
                                       options:0];
    
    NSInteger age = [ageComponents year];
    
    NSLog(@"birthday - %@", [dateFormatter stringFromDate:currentDate]);
    NSLog(@"current date - %@", [dateFormatter stringFromDate:birthday]);
    NSLog(@"User age is - %ld", (long)age);
    
    return age;
}

@end
