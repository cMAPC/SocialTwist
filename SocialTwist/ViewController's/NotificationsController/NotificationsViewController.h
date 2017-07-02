//
//  NotificationsViewController.h
//  SocialTwist
//
//  Created by Marcel  on 6/8/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RequestManager.h"
#import "FriendRequestCell.h"

#import "UserData.h"
#import <DLImageLoader.h>

@interface NotificationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
