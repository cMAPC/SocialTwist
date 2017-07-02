//
//  UserProfileViewController.h
//  SocialTwist
//

#import <UIKit/UIKit.h>

#import "RequestManager.h"

@interface UserProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString* userID;
@end
