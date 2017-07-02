//
//  EventViewController.h
//  SocialTwist
//
//  Created by Marcel  on 6/30/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDWebImage/UIImageView+WebCache.h>
#import "RequestManager.h"
#import "EventData.h"
#import "AttendersViewController.h"

@interface EventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UIButton *attendButton;

@property (strong, nonatomic) EventData* event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
