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
#import "CommentData.h"
#import "AttendersViewController.h"
#import "UserProfileViewController.h"
#import "WriteCommentBox.h"
#import "CommentCell.h"
#import "TableHeaderView.h"
#import <NSDate+TimeAgo.h>

@interface EventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) EventData* event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
