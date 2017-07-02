//
//  SearchResultController.h
//  SocialTwist
//

#import <UIKit/UIKit.h>
#import "SearchResultCell.h"
#import "UserProfileViewController.h"
#import <DLImageLoader.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchResultController : UITableViewController

@property (strong, nonatomic) NSArray* searchResult;

@end
