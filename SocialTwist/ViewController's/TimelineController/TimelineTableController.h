//
//  TableViewController.h
//  TableViewDynamicSize
//

#import <UIKit/UIKit.h>

#import "TimelineCellController.h"
#import "PostEventCell.h"
#import "EventContent.h"
#import "KeyboardViewController.h"
#import "MapViewController.h"

@interface TimelineTableController : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
