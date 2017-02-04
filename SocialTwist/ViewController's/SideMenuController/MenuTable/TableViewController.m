//
//  TableViewController.m
//  MapModule
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *thumbnailsArray;

@end



@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Profile",
                         @"News",
                         @"Articles",
                         @"Video",
                         @"Music"];
    
    self.thumbnailsArray = @[@"imageLeft.png",
                             @"imageRight.png",
                             @"imageRoot.png",
                             ];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileCustomCell"];
    
    
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:120];
    
    
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}


#pragma mark - UITableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        TableViewCell* profileCustomCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCustomCell"];
        
        profileCustomCell.imageView.translatesAutoresizingMaskIntoConstraints = YES;
        profileCustomCell.cellImage.image = [UIImage imageNamed:@"imageRoot"];
        
//        [profileCustomCell.imageView setContentMode:UIViewContentModeScaleAspectFit];
//        profileCustomCell.imageView.layer.masksToBounds = YES;
//        profileCustomCell.imageView.layer.cornerRadius = 50;
//        [profileCustomCell.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [profileCustomCell.contentView setNeedsLayout];
//        [profileCustomCell.contentView layoutIfNeeded];
        return profileCustomCell;
    }

        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.titlesArray[indexPath.row];
        return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return indexPath.row == 0 ? 120.f : 44.f;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    
    /*
    if(indexPath.row == 1) {
    
    TableViewController* leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    MainViewController *mainViewController = [[MainViewController alloc] init];

    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController1"];
    
    mainViewController.rootViewController = navigationController;
    mainViewController.leftViewController = leftViewController;
    
    [self presentViewController:mainViewController animated:YES completion:nil];
    
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
    } else {
    
        TableViewController* leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
        MainViewController *mainViewController = [[MainViewController alloc] init];
        
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController2"];
        
        mainViewController.rootViewController = navigationController;
        mainViewController.leftViewController = leftViewController;
        
        [self presentViewController:mainViewController animated:YES completion:nil];
        
        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
    }
     */
}

@end
