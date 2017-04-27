//
//  ContainerViewController.h
//  MapModule
//

#import <UIKit/UIKit.h>
#import "AKASegmentedControl.h"
#import <LGSideMenuController.h>
#import "SearchResultController.h"
#import "TimelineTableController.h"

@interface ContainerViewController : UIViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UIView *mapViewChild;
@property (weak, nonatomic) IBOutlet UIView *timelineViewChild;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;

- (IBAction)searchRightBarItemAction:(UIBarButtonItem *)sender;

@end
