//
//  TableViewController.h
//  TableViewDynamicSize
//

#import <UIKit/UIKit.h>

#import "TimelineCellController.h"
#import "PostEventCell.h"
#import "EventContent.h"
#import "KeyboardViewController.h"

@interface TimelineTableController : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
