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
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.searchResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",
                             [[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                             [[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"lastName"]
                             ]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController* userProfileController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    
//    [userProfileController setName:[self.searchResult objectAtIndex:indexPath.row]];
    
    [userProfileController setUserId:[[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"userId"]];
    
    [userProfileController setName:[NSString stringWithFormat:@"%@ %@",
                                    [[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"firstName"],
                                    [[self.searchResult objectAtIndex:indexPath.row] valueForKey:@"userId"]
                                    ]];
    
    [self.presentingViewController.navigationController pushViewController:userProfileController animated:YES];
}

@end
