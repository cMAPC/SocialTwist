//
//  EventFilterTableView.h
//  SocialTwist
//
//  Created by Marcel  on 5/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventFilterCell.h"

@interface EventFilterTableView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

