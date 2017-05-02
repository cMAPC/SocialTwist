//
//  EventFilterTableController.m
//  SocialTwist
//
//  Created by Marcel  on 5/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "EventFilterTableController.h"
#import "ContainerViewController.h"

@interface EventFilterTableController ()

@end

@implementation EventFilterTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventCategorys = [[NSMutableArray alloc] init];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Validate" style:UIBarButtonItemStylePlain target:self action:@selector(validateSelectedEventCategories)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Validate" style:UIBarButtonItemStylePlain target:self action:@selector(validateSelectedEventCategories)];
    [self.navigationItem setRightBarButtonItem:button];
}

-(void)validateSelectedEventCategories {
//    MapViewController* mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationControllerID"];
//    mapViewController.selectedCategories = self.eventCategorys;
   // [self presentViewController:mapViewController animated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController]
    ContainerViewController* mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationControllerID"];
//    [mapViewController setTrash:@"Marcel"];
//    UIView* map = mapViewController.mapViewChild;
//    MapViewController* mapp = (MapViewController *)[[(ContainerViewController*) mapViewController childViewControllers] objectAtIndex:1];
//    
//    [mapp trashAction:_eventCategorys];
    [self presentViewController:mapViewController animated:YES completion:nil];
    NSLog(@"Marcel");
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    if (self.isMovingFromParentViewController) {
        NSLog(@"da");
    
        
    
        

//        MapViewController* map = (MapViewController *)self.presentedViewController;
//        map.selectedCategories = self.eventCategorys;
//        self.navigationController.navigationBar.topItem.titleView = nil;
//        self.navigationController.navigationBar.topItem.title = @"News";
//        [self.navigationItem setTitle:@"Marcel"];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContainerViewController* userProfileController = [storyboard instantiateViewControllerWithIdentifier:@"ContainerViewControllerID"];
        
//        MapViewController* mapViewController = (MapViewController *)userProfileController.childViewControllers[0];
        MapViewController* mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewControllerID"];
//        mapViewController.navigationItem.titleView = nil;
//        mapViewController.navigationItem.title = @"Marcel";
        
//        UINavigationItem* navigation = (UINavigationItem *)userProfileController.navigationItem;
//         navigation.titleView = nil;
//                   navigation.title = @"Marcel";
        
        [mapViewController setTrash:@"Marcel"];
        [mapViewController trashAction:self.eventCategorys];
//        userProfileController.mapViewChild.se = self.eventCategorys;
        
//        [self.presentingViewController.navigationController pushViewController:mapViewController animated:YES];

    }
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchDidChangeState:(id)sender {
    UISwitch* switchControl = (UISwitch *)sender;
    CGPoint switchControlsPositionPoint = [switchControl convertPoint:switchControl.bounds.origin toView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:switchControlsPositionPoint];
    if ([switchControl isOn]) {
        [self.eventCategorys addObject:[NSNumber numberWithInteger:indexPath.row]];
//        [self.navigationItem.leftBarButtonItem setTitle:@"Confirm"];
        self.navigationController.navigationBar.backItem.title = @"Confirm";
    }
    else
    {
        self.navigationController.navigationBar.backItem.title = @"News";
        [self.eventCategorys removeObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    NSLog(@"Array = %@", self.eventCategorys);
}
@end
