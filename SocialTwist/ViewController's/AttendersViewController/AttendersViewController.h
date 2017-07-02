//
//  AttendersViewController.h
//  SocialTwist
//
//  Created by Marcel  on 7/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RequestManager.h"
#import "UserData.h"

@interface AttendersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString* eventID;

@end
