//
//  SearchResultController.m
//  SocialTwist
//

#import "SearchResultController.h"

@interface SearchResultController () <UITableViewDataSource>

@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableWithCustomCell];
    [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    [self.tableView setEstimatedRowHeight:200];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}

-(void)initTableWithCustomCell {
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil]
       forCellReuseIdentifier:@"SearchResultCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",
                             [[self.searchResult objectAtIndex:indexPath.row] firstName],
                             [[self.searchResult objectAtIndex:indexPath.row] lastName]
                             ]];
    
    NSString* userImageURL = [[self.searchResult objectAtIndex:indexPath.row] picture];
    [[DLImageLoader sharedInstance] imageFromUrl:userImageURL
                                       completed:^(NSError *error, UIImage *image) {
                                           [cell.pictureImageView setImage:image];
                                       }];
    
//    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:userImageURL]) {
//        [cell.pictureImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageURL]];
//    } else {
//        [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:userImageURL]
//                                 placeholderImage:[UIImage imageNamed:@"avatar.jpg"]];    }


/* AFNetworking parse
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//    NSString* userImageURL = [[self.searchResult objectAtIndex:indexPath.row] picture];
//    UIImage* userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [cell.pictureImageView setImage:userImage];
        });
    });
*/
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController* userProfileController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    
    UserData *user = self.searchResult[indexPath.row];
    [userProfileController setUserID:user.userID.stringValue];
    
    [self.presentingViewController.navigationController pushViewController:userProfileController animated:YES];
}

@end
