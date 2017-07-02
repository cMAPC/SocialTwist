//
//  EventViewController.m
//  SocialTwist
//
//  Created by Marcel  on 6/30/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController () {
    CGFloat newHeight;
}

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.event.creator.firstName, self.event.creator.lastName];
    self.eventContentLabel.text = [NSString stringWithFormat:@"\r %@ \r", self.event.subtitle];
    self.attendersLabel.text = [NSString stringWithFormat:@"%@ attenders \r", self.event.attenders.stringValue];
    
    if (self.event.creator.picture) // ???????
        self.userImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.event.creator.thumbnail];
    else
        self.userImageView.image = [UIImage imageNamed:@"avatar.jpg"];
    
    if (self.event.picture) {
        self.eventImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.event.picture];
        [self adjustEventImageViewHeight];
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAttendersAction:)];
    [self.attendersLabel addGestureRecognizer:tapGesture];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:newHeight]];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    BOOL endOfTable = (scrollView.contentOffset.y >= ((40 * 40) - scrollView.frame.size.height)); // Here 40 is row height
    
    if (endOfTable && !scrollView.dragging && !scrollView.decelerating)
    {
        [self.tableView setScrollEnabled:YES];
    }
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

#pragma mark - Adjustments
-(void)adjustEventImageViewHeight {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    newHeight = screenWidth / self.eventImageView.image.size.width * self.eventImageView.image.size.height;
    [self.eventImageView removeConstraint:self.eventImageView.constraints.lastObject];
}

#pragma mark - Actions
- (IBAction)attendAction:(UIButton *)sender {
    [[RequestManager sharedManager] attendOnEventWithID:self.event.eventID.stringValue
                                                success:^(id responseObject) {
                                                    NSLog(@"Attend response - %@", responseObject);
                                                } fail:^(NSError *error, NSInteger statusCode) {
                                                    
                                                }];
}

-(void)viewAttendersAction:(UIGestureRecognizer *)gesture {
    NSLog(@"Tapped");
    AttendersViewController* attendersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendersViewControllerID"];
    
    attendersViewController.eventID = self.event.eventID.stringValue;
    [self.navigationController pushViewController:attendersViewController animated:YES];
}
@end
