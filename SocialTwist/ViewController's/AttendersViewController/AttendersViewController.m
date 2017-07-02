//
//  AttendersViewController.m
//  SocialTwist
//
//  Created by Marcel  on 7/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "AttendersViewController.h"

@interface AttendersViewController () {
    NSMutableArray* attendersArray;
}

@end

@implementation AttendersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setEstimatedRowHeight:200];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    [[RequestManager sharedManager] getAttendersForEventWithID:self.eventID
                                                       success:^(id responseObject) {
                                                           attendersArray = responseObject;
                                                           [self.tableView reloadData];
                                                       } fail:^(NSError *error, NSInteger statusCode) {
                                                           
                                                       }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [attendersArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UserData* user = attendersArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:user.thumbnail]) {
        [cell.imageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:user.thumbnail]];
    }
    else
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"avatar.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (!image) {
                                         [cell.imageView setImage:[UIImage imageNamed:@"avatar.jpg"]];
                                     }
                                     [cell layoutSubviews];
                                     [cell layoutIfNeeded];
                                     [cell setNeedsLayout];
                                 }];
    }
    
    return cell;
}

@end
