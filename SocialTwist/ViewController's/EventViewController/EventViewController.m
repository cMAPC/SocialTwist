//
//  EventViewController.m
//  SocialTwist
//
//  Created by Marcel  on 6/30/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "EventViewController.h"

//#import "CalloutView.h"

@interface EventViewController () {
    WriteCommentBox* writeCommentBoxView;
}

@property (strong, nonatomic) NSMutableArray* commentsArray;

@end


@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 45, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 45, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:400];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];

    // WriteCommentBox
    writeCommentBoxView = [[WriteCommentBox alloc] init];
    [self.view addSubview:writeCommentBoxView];
    [writeCommentBoxView.postCommentButton addTarget:self
                                              action:@selector(postCommentAction:)
                                    forControlEvents:UIControlEventTouchUpInside];
    
    // TableHeader
    TableHeaderView* tableHeaderView = [[TableHeaderView alloc] init];
    [self.tableView setTableHeaderView:tableHeaderView];
    
    tableHeaderView.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.event.creator.firstName, self.event.creator.lastName];
    tableHeaderView.eventContentLabel.text = self.event.subtitle;
    tableHeaderView.attendersLabel.text = [NSString stringWithFormat:@"%@ attenders", self.event.attenders.stringValue];

    if (self.event.creator.picture) // ???????
        tableHeaderView.userImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.event.creator.thumbnail];
    else
        tableHeaderView.userImageView.image = [UIImage imageNamed:@"avatar.jpg"];
    
    if (self.event.picture) {
        tableHeaderView.eventImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.event.picture];
    }
    
    [tableHeaderView.attendButton addTarget:self
                                     action:@selector(attendAction:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* userInfoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewUserProfile:)];
    [tableHeaderView.userInfoView addGestureRecognizer:userInfoTapGesture];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAttendersAction:)];
    [tableHeaderView.attendersLabel addGestureRecognizer:tapGesture];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[RequestManager sharedManager] getCommentsForEventWithID:self.event.eventID.stringValue
                                                      success:^(id responseObject) {
                                                          self.commentsArray = [NSMutableArray arrayWithArray:responseObject];
                                                          [self.tableView reloadData];
                                                      } fail:^(NSError *error, NSInteger statusCode) {
                                                          
                                                      }];

}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];

    CommentData *comment = self.commentsArray[indexPath.row];
    NSString *userImageURL = comment.author.thumbnail;
    
    cell.commentLabel.text = comment.text;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", comment.author.firstName, comment.author.lastName];
    cell.timeLabel.text = [[self convertDate:comment.timestamp] dateTimeAgo];
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:userImageURL]) {
        cell.userImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageURL];
    }
    else
    {
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageURL]
                              placeholderImage:[UIImage imageNamed:@"avatar.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (!image)
                                             cell.userImageView.image = [UIImage imageNamed:@"avatar.jpg"];
                                         
                                         [cell layoutSubviews];
                                     }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    
    CommentData *comment = self.commentsArray[indexPath.row];
    profileViewController.userID = comment.author.userID.stringValue;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - WriteCommentBox View Action's
-(void)postCommentAction:(UIButton *)sender {
    [[RequestManager sharedManager] postComment:writeCommentBoxView.writeCommentTextView.text
                                  onEventWithID:self.event.eventID.stringValue
                                        success:^(id responseObject) {
                                            [self.view endEditing:YES];
                                            [writeCommentBoxView setPlaceholderOnTextView:writeCommentBoxView.writeCommentTextView];
                                            
                                            NSMutableArray *temp = [NSMutableArray array];
                                            [temp insertObject:responseObject atIndex:0];
                                            [temp addObjectsFromArray:self.commentsArray];
                                            self.commentsArray = [NSMutableArray arrayWithArray:temp];
                                            
                                            [self.tableView beginUpdates];
                                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                                                  withRowAnimation:UITableViewRowAnimationTop];
                                            [self.tableView endUpdates];
                                        } fail:^(NSError *error, NSInteger statusCode) {
                                            
                                        }];
}

#pragma mark - Table HeaderView Action's
-(void)viewUserProfile:(UIGestureRecognizer *)sender {
    UserProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    
    profileViewController.userID = self.event.creator.userID.stringValue;
    [self.navigationController pushViewController:profileViewController animated:YES];
}
-(void)attendAction:(UIButton *)sender {
    [[RequestManager sharedManager] attendOnEventWithID:self.event.eventID.stringValue
                                                success:^(id responseObject) {
                                                    NSLog(@"Attend response - %@", responseObject);
                                                } fail:^(NSError *error, NSInteger statusCode) {

                                                }];
}

-(void)viewAttendersAction:(UIGestureRecognizer *)sender {
    NSLog(@"Tapped");
    AttendersViewController* attendersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendersViewControllerID"];
    
    attendersViewController.eventID = self.event.eventID.stringValue;
    [self.navigationController pushViewController:attendersViewController animated:YES];
}

#pragma mark - Helpers
-(NSDate *)convertDate:(NSString *)date {
    NSDateFormatter* dateFormmater = [[NSDateFormatter alloc] init];
    NSString *year = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSArray *splitString = [year componentsSeparatedByCharactersInSet:delimiters];
    year = [splitString objectAtIndex:0];
    
    [dateFormmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormmater.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *temp = [[NSDate alloc] init];
    temp = [dateFormmater dateFromString:year];
    
    return temp;
}

@end
