//
//  FriendListViewController.h
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListCell.h"
#import "RequestManager.h"
#import "UserProfileViewController.h"
#import <DLImageLoader.h>

@interface FriendListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
