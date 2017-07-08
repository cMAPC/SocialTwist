//
//  TableViewController.h
//  TableViewDynamicSize
//

#import <UIKit/UIKit.h>

#import "EventCell.h"
#import "PostEventCell.h"
#import "EventContent.h"
#import "KeyboardViewController.h"
#import "MapViewController.h"
#import "Utilities.h"
#import <DLImageLoader.h>
#import "EventViewController.h"

#import <UIImageView+AFNetworking.h>
#import <AFImageDownloader.h>
#import "LoadingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TimelineTableController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) KeyboardViewController* eventCategoryKeyboard;

@end
