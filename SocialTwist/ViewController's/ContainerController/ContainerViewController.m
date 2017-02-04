//
//  ContainerViewController.m
//  MapModule
//

#import "ContainerViewController.h"

@interface ContainerViewController (){
    UIView * sliderView;
}

@end

@implementation ContainerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
            sliderView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBarView.frame.size.width/2,
                                                                self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                                self.tabBarView.frame.size.width/2,
                                                                2.0f)];
            [sliderView setBackgroundColor:[UIColor blueColor]];
            [self.view addSubview:sliderView];
        
        
        // Initialization of the segmented control
        AKASegmentedControl *segmentedControl = [[AKASegmentedControl alloc] initWithFrame:self.tabBarView.frame];
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        // Setting the behavior mode of the control
        [segmentedControl setSegmentedControlMode:AKASegmentedControlModeSticky];
        
        // Button 1
        UIButton *buttonSocial = [[UIButton alloc] init];
        UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"social-icon@2x.png"];
        [buttonSocial setTitle:@"marcel" forState:UIControlStateNormal];
        [buttonSocial setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [buttonSocial setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
        [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
        [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
        [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
        
        // Button 2
        UIButton *buttonSettings = [[UIButton alloc] init];
        UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"settings-icon.png"];
        
        [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateNormal];
        [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateSelected];
        [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateHighlighted];
        [buttonSettings setImage:buttonSettingsImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
        
        // Setting the UIButtons used in the segmented control
        [segmentedControl setButtonsArray:@[buttonSocial, buttonSettings]];
        [segmentedControl setSelectedIndex:1];
        
        // Adding your control to the view
        [self.view addSubview:segmentedControl];
        
    });
}

#pragma mark - Action
-(void)segmentedControlValueChanged:(AKASegmentedControl *) sender {
    
    if (sender.selectedIndexes.firstIndex == 0) {
        [UIView animateWithDuration:(0.5) animations:^{
            [sliderView removeFromSuperview];
            self.timelineViewChild.alpha = 1;
            self.mapViewChild.alpha = 0;
            [self rightToLeftAnimation];
        }];
    } else {
        [UIView animateWithDuration:(0.5) animations:^{
            [sliderView removeFromSuperview];
            self.timelineViewChild.alpha = 0;
            self.mapViewChild.alpha = 1;
            [self leftToRightAnimation];
        }];
    }
}


#pragma mark - Animation
-(void) rightToLeftAnimation{
    sliderView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBarView.frame.size.width/2,
                                                        self.tabBarView.frame.origin.y + self.tabBarView.frame.size.height - 2,
                                                        self.tabBarView.frame.size.width/2,
                                                        2.0f)];
    [sliderView setBackgroundColor:[UIColor blueColor]];
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
    [sliderView setBackgroundColor:[UIColor blueColor]];
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

@end
