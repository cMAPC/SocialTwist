//
//  EventFilterTableController.h
//  SocialTwist
//
//  Created by Marcel  on 5/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface EventFilterTableController : UITableViewController

@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switchCollection;
@property (strong, nonatomic) NSMutableArray* eventCategorys;

- (IBAction)switchDidChangeState:(id)sender;

@end
