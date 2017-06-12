//
//  UserProfileViewController.h
//  SocialTwist
//

#import <UIKit/UIKit.h>

#import "RequestManager.h"

@interface UserProfileViewController : UIViewController

@property (weak, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* userId;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
