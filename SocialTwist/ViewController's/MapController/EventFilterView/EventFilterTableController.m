//
//  EventFilterTableController.m
//  SocialTwist
//
//  Created by Marcel  on 5/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "EventFilterTableController.h"

@interface EventFilterTableController ()

@end

@implementation EventFilterTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventCategories = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"eventCategories"]];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    
    UIBarButtonItem* validateRightBarButton = [[UIBarButtonItem alloc]
                                               initWithTitle:@"Validate"
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(validateFiltersAction:)];
    
    [self.navigationItem setRightBarButtonItem:validateRightBarButton];
    
    for (UISwitch* switchControl in self.switchCollection) {
        if ([self.eventCategories containsObject:[NSNumber numberWithInteger:switchControl.tag].stringValue])
            [switchControl setOn:YES animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    if (self.isMovingFromParentViewController) {
        NSLog(@"isMovingFromParentViewController");
        // do something when navigation controller back button is pressed
    }
}

#pragma mark - Actions
-(void)validateFiltersAction:(id) sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.eventCategories forKey:@"eventCategories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ContainerViewController* controller = (ContainerViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
    MapViewController* mapController = (MapViewController *)[[controller childViewControllers] objectAtIndex:1];
    
    [mapController setSelectedCategories:self.eventCategories];
    [mapController filterEventsByCategories];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchDidChangeState:(id)sender {
    UISwitch* switchControl = (UISwitch *)sender;
    
    /* number version
    if ([switchControl isOn])
        [self.eventCategories addObject:[NSNumber numberWithInteger:switchControl.tag]];
    
    else
        [self.eventCategories removeObject:[NSNumber numberWithInteger:switchControl.tag]];
    
    
    NSLog(@"Event Filter Categories = %@", self.eventCategories);
    */
    
    if ([switchControl isOn])
        [self.eventCategories addObject:[NSNumber numberWithInteger:switchControl.tag].stringValue];
    
    else
        [self.eventCategories removeObject:[NSNumber numberWithInteger:switchControl.tag].stringValue];
    NSLog(@"Event Filter Categories = %@", self.eventCategories);
    /* withoutTag
    UISwitch* switchControl = (UISwitch *)sender;
    CGPoint switchControlsPositionPoint = [switchControl convertPoint:switchControl.bounds.origin toView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:switchControlsPositionPoint];
    
    if ([switchControl isOn]) {
        [self.eventCategorys addObject:[NSNumber numberWithInteger:indexPath.row]];
        
        [self.navigationItem.leftBarButtonItem setTitle:@"Confirm"];
        self.navigationController.navigationBar.backItem.title = @"Confirm";
    }
    else
    {
        [self.eventCategorys removeObject:[NSNumber numberWithInteger:indexPath.row]];
        
        self.navigationController.navigationBar.backItem.title = @"News";
    }
    */
}

@end
