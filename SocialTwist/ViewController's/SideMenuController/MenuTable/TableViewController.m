//
//  TableViewController.m
//  MapModule
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *itemsTextArray;
@property (strong, nonatomic) NSArray *itemsImageArray;

@end



@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsTextArray = @[@"Notifications",
                            @"Map",
                            @"Messages",
                            @"Friends",
                            @"Settings"];
    
    self.itemsImageArray = @[@"notifications.png",
                             @"map.png",
                             @"message.png",
                             @"friends.png",
                             @"settings.png",
                             @"settings.png"];
    
    
//    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 0.f, 0.f);

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"menuCell"];
    
    
    [self.tableView setBackgroundView:[Utilities setGradientForView:self.tableView]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:120];
    
    
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsTextArray.count + 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
        [cell setBackgroundColor:[UIColor clearColor]];
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Menu"];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            if ([UIScreen mainScreen].bounds.size.width < 370) {
                cell.indentationLevel = 12;
            }
            else {
                cell.indentationLevel = 15;
            }
        }
        return cell;
    }
    
    if(indexPath.row == 1) {
        TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
//        profileCustomCell.imageView.translatesAutoresizingMaskIntoConstraints = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                                [[NSUserDefaults standardUserDefaults] objectForKey:@"name"],
                                                [[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"]
                                                ];
            
            NSString* userImageURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"picture"];
            
            if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:userImageURL]) {
                cell.userImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageURL];
            }
            else
            {
                [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageURL]
                                      placeholderImage:[UIImage imageNamed:@"avatar.jpg"]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 if (!image)
                                                     cell.userImageView.image = [UIImage imageNamed:@"avatar.jpg"];
                                                 
                                                 [cell layoutSubviews];
                                             }];
            }
            
        });
        
        return cell;
    }
    
    else {
        MenuCell* menuCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
        menuCell.itemImageView.image = [UIImage imageNamed:self.itemsImageArray[indexPath.row - 3]];
        menuCell.itemTextLabel.text = self.itemsTextArray[indexPath.row - 3];
        
        if (indexPath.row != 3 && indexPath.row != 5)
            [menuCell.countView setHidden:YES];
        
        return menuCell;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    
    TableViewController* leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewControllerID"];
    MainViewController* mainViewController = [[MainViewController alloc] init];
    
    UINavigationController* containerNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationControllerID"];
    
    UINavigationController* notificationsNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsNavigationControllerID"];
    
    UINavigationController* friendListNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendListNavigationControllerID"];
    
    UINavigationController* userProfileNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileNavigationControllerID"];
    
    UserProfileViewController* profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileControllerID"];
    UIBarButtonItem *leftMenuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:profileController
                                                                         action:@selector(showLeftViewAnimated:)];
    [leftMenuBarButton setTintColor:[UIColor whiteColor]];
    [profileController.navigationItem setLeftBarButtonItem:leftMenuBarButton];
    [userProfileNavigationController setViewControllers:@[profileController]];
    
    switch (indexPath.row) {
        case 1:
            [mainViewController setRootViewController:userProfileNavigationController];
            [mainViewController setLeftViewController:leftViewController];
            [self presentViewController:mainViewController animated:YES completion:nil];
            break;
        case 3:
            [mainViewController setRootViewController:notificationsNavigationController];
            [mainViewController setLeftViewController:leftViewController];
            [self presentViewController:mainViewController animated:YES completion:nil];
            break;
        case 4:
            [mainViewController setRootViewController:containerNavigationController];
            [mainViewController setLeftViewController:leftViewController];
            [self presentViewController:mainViewController animated:YES completion:nil];
            break;
        case 5:
            break;
        case 6:
            [mainViewController setRootViewController:friendListNavigationController];
            [mainViewController setLeftViewController:leftViewController];
            [self presentViewController:mainViewController animated:YES completion:nil];
            break;
        case 7:
            break;
        default:
            break;
    }

}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}

@end
