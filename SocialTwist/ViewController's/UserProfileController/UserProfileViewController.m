//
//  UserProfileViewController.m
//  SocialTwist
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameLabel setText:self.name];
}

- (IBAction)addFriend:(id)sender {
    [[RequestManager sharedManager] addFriendWithId:self.userId
                                            success:^(id responseObject) {
                                                NSLog(@"Add friend succes response : %@", responseObject);
                                            } fail:^(NSError *error, NSInteger statusCode) {
                                                
                                            }];
}

@end
