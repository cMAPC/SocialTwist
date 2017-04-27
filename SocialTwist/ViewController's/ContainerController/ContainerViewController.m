//
//  ContainerViewController.m
//  MapModule
//

#import "ContainerViewController.h"

@interface ContainerViewController (){
    UIView * sliderView;
    
    UISearchController* searchController_;
    SearchResultController* searchResultController;
    
    NSArray* nameArray;
    NSArray* searchResultArray;
}

@end

@implementation ContainerViewController

- (void)initTopSegmentedControl {
    // Initialization of the segmented control
    AKASegmentedControl *segmentedControl = [[AKASegmentedControl alloc] initWithFrame:self.tabBarView.frame];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Setting the behavior mode of the control
    [segmentedControl setSegmentedControlMode:AKASegmentedControlModeSticky];
    
    // Button 1
    UIButton *buttonTimeline = [[UIButton alloc] init];
    
    [buttonTimeline.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [buttonTimeline setTitle:@"Timeline" forState:UIControlStateNormal];
    [buttonTimeline setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [buttonTimeline setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTimeline setTitleColor:[UIColor colorWithRed:(155/255.0) green:186/255.0 blue:205/255.0 alpha:1.0]
                         forState:UIControlStateSelected];
    
    UIImage *buttonTimelineImageNormal = [UIImage imageNamed:@"timeline-icon"];
    UIImage *buttonTimelineImageSelected = [UIImage imageNamed:@"timeline-icon-hightlighted"];
    
    
    [buttonTimeline setImage:buttonTimelineImageNormal forState:UIControlStateNormal];
    [buttonTimeline setImage:buttonTimelineImageSelected forState:UIControlStateSelected];
    [buttonTimeline setImage:buttonTimelineImageSelected forState:UIControlStateHighlighted];
    [buttonTimeline setImage:buttonTimelineImageSelected forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *buttonMap = [[UIButton alloc] init];
    
    [buttonMap.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [buttonMap setTitle:@"Map" forState:UIControlStateNormal];
    [buttonMap setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [buttonMap setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonMap setTitleColor:[UIColor colorWithRed:(155/255.0) green:186/255.0 blue:205/255.0 alpha:1.0]
                    forState:UIControlStateSelected];
    
    
    UIImage *buttonMapImageNormal = [UIImage imageNamed:@"map-icon"];
    UIImage *buttonMapImageSelected = [UIImage imageNamed:@"map-icon-hightlighted"];
    
    [buttonMap setImage:buttonMapImageNormal forState:UIControlStateNormal];
    [buttonMap setImage:buttonMapImageSelected forState:UIControlStateSelected];
    [buttonMap setImage:buttonMapImageSelected forState:UIControlStateHighlighted];
    [buttonMap setImage:buttonMapImageSelected forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Setting the UIButtons used in the segmented control
    [segmentedControl setButtonsArray:@[buttonTimeline, buttonMap]];
    [segmentedControl setSelectedIndex:1];
    
    [self.view addSubview:segmentedControl];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameArray = @[@"Max", @"Anton", @"Jenea", @"Vadim", @"Felicia", @"Lilia", @"Kuzia", @"Sandu"];
    searchResultController = [[SearchResultController alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initSlider];
        [self initTopSegmentedControl];
    });
}

- (void)initSlider {
    sliderView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBarView.frame.size.width/2,
                                                          self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                          self.tabBarView.frame.size.width/2,
                                                          2.0f)];
    [sliderView setBackgroundColor:[UIColor colorWithRed:(155/255.0) green:(186/255.0) blue:(205/255.0) alpha:1]];
    [self.view addSubview:sliderView];
}


#pragma mark - Action
-(void)segmentedControlValueChanged:(AKASegmentedControl *) sender {
    

    

    TimelineTableController * obj = (TimelineTableController *)self.childViewControllers[0];
    if ([obj isPosting]) {
        [Utilities showAlertControllerWithTitle:@"Error"
                                        message:@"Cancel or Discard ?"
                                     buttonType:UIAlertButtonDiscard
                                  buttonHandler:^{
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.view endEditing:YES];
                                              [obj restoreEmptyPostCell];
                                              [sender setSelectedIndex:1];
                                              [self showMapController];
                                                });
                                      
                                     
                                  } onViewController:self];
        
        [sender setSelectedIndex:0];
        return;
    }
   
    MapViewController * obj1 = (MapViewController *)self.childViewControllers[1];
    if ([obj1 isPosting]) {
        [Utilities showAlertControllerWithTitle:@"Error"
                                        message:@"Cancel or Discard ?"
                                     buttonType:UIAlertButtonDiscard
                                  buttonHandler:^{
                                      [sender setSelectedIndex:0];
                                      [self showTimelineController];
                                      [obj1 dismissPostAnnotationView];
                                  } onViewController:self];
        
        [sender setSelectedIndex:1];
        return;
    }
    
    if (sender.selectedIndexes.firstIndex == 0) {
        [self showTimelineController];
    }
    else
    {
        [self showMapController];
    }
}

-(void)showTimelineController {
    [UIView animateWithDuration:(0.5) animations:^{
        [sliderView removeFromSuperview];
        self.timelineViewChild.alpha = 1;
        self.mapViewChild.alpha = 0;
        [self rightToLeftAnimation];
        
        MapViewController * mapViewController = (MapViewController *)self.childViewControllers[1];
        if (![[mapViewController eventCategoryKeyboard] isHidden]) {
            [[mapViewController eventCategoryKeyboard] hideAnimated:YES];
        }
        
        [mapViewController.view endEditing:YES];
    }];

}

-(void)showMapController {
    [UIView animateWithDuration:(0.5) animations:^{
        [sliderView removeFromSuperview];
        self.timelineViewChild.alpha = 0;
        self.mapViewChild.alpha = 1;
        [self leftToRightAnimation];
        
        TimelineTableController * timelineController = (TimelineTableController *)self.childViewControllers[0];
        if (![[timelineController eventCategoryKeyboard] isHidden]) {
            [[timelineController eventCategoryKeyboard] hideAnimated:YES];
        }
        
        [timelineController.view endEditing:YES];
    }];

}

#pragma mark - Animation
-(void) rightToLeftAnimation{
    sliderView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBarView.frame.size.width/2,
                                                        self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                        self.tabBarView.frame.size.width/2,
                                                        2.0f)];
    [sliderView setBackgroundColor:[UIColor colorWithRed:(155/255.0) green:(186/255.0) blue:(205/255.0) alpha:1]];
    [self.view addSubview:sliderView];
    
    [UIView animateWithDuration:30.0f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [sliderView setFrame:CGRectMake(0.0f,
                                                       self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                       self.tabBarView.frame.size.width/2,
                                                       2.0f)];
                     }
                     completion:nil];

}

-(void) leftToRightAnimation{
    sliderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                        self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                        self.tabBarView.frame.size.width/2,
                                                        2.0f)];
    [sliderView setBackgroundColor:[UIColor colorWithRed:(155/255.0) green:(186/255.0) blue:(205/255.0) alpha:1]];
    [self.view addSubview:sliderView];
    
    [UIView animateWithDuration:30.0f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [sliderView setFrame:CGRectMake(self.tabBarView.frame.size.width/2,
                                                       self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                       self.tabBarView.frame.size.width/2,
                                                       2.0f)];
                     }
                     completion:nil];
    
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [self filterContentForSearchText:searchController.searchBar.text];
    
    SearchResultController* searchResultController_ = (SearchResultController *)searchController_.searchResultsController;
    searchResultController_.searchResult = searchResultArray;
    [searchResultController_.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:FALSE animated:YES];
    
    [self.navigationItem setTitleView:nil];
    [self.navigationItem setTitle:@"News"];

    
    UIBarButtonItem* sideMenuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showLeftViewAnimated:)];
    [sideMenuBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem* searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search-icon"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(searchRightBarItemAction:)];
    [searchBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setLeftBarButtonItem:sideMenuBarButtonItem];
    [self.navigationItem setRightBarButtonItem:searchBarButtonItem];
    
}

-(void)filterContentForSearchText:(NSString *) searchText {
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    searchResultArray = [nameArray filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - NavigationController Buttons Action
- (IBAction)searchRightBarItemAction:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    searchController_ = [[UISearchController alloc] initWithSearchResultsController:searchResultController];
    
    searchController_.delegate = self;
    searchController_.searchBar.delegate = self;
    searchController_.searchResultsUpdater = self;
    
    [searchController_ setHidesNavigationBarDuringPresentation:FALSE];
    [searchController_ setDimsBackgroundDuringPresentation:FALSE];
    
    //CostumizeSearchBar
    UITextField* searchTextField = [searchController_.searchBar valueForKey:@"searchField"];
    UILabel* searchPlaceholderLabel = [searchTextField valueForKey:@"placeholderLabel"];
    [searchTextField setBackgroundColor:[UIColor clearColor]];
    [searchPlaceholderLabel setText:@"Search anything here..."];
    [searchPlaceholderLabel setTextColor:[UIColor colorWithRed:205/255.0 green:221/255.0 blue:230/255.0 alpha:1]];
    [searchTextField setLeftViewMode:UITextFieldViewModeNever];
    [searchController_.searchBar setSearchTextPositionAdjustment:UIOffsetMake(8, 0)];
    UIBarButtonItem* cancelButtonInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    [cancelButtonInSearchBar setImage:[UIImage imageNamed:@"search-icon"]];
    [cancelButtonInSearchBar setTintColor:[UIColor whiteColor]];
    [cancelButtonInSearchBar setTitle:nil];
    
    
    [self.navigationItem setTitleView:searchController_.searchBar];
    
    [searchController_.searchBar becomeFirstResponder];
    
}

@end
