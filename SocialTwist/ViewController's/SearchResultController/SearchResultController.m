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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSString* userImageURL = [[self.searchResult objectAtIndex:indexPath.row] picture];
    UIImage* userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [cell.pictureImageView setImage:userImage];
        });
    });
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController* userProfileController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    
    [userProfileController setUserId:[[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"userID"]];
    
    [userProfileController setName:[NSString stringWithFormat:@"%@ %@",
                                    [[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                                    [[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"userID"]
                                    ]];
    
    [self.presentingViewController.navigationController pushViewController:userProfileController animated:YES];
}

@end
