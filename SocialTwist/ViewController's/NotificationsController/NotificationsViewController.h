//
//  NotificationsViewController.h
//  SocialTwist
//
//  Created by Marcel  on 6/8/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RequestManager.h"
#import "SearchContent.h"
#import "FriendRequestCell.h"

@interface NotificationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
