//
//  UserProfileViewController.h
//  SocialTwist
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property (weak, nonatomic) NSString* name;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
