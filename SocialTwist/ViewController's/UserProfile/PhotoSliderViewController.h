//
//  PhotoSliderViewController.h
//  SocialTwist
//
//  Created by Vadim on 6/15/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSliderViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *images;
@property (assign,nonatomic) NSInteger indexpath;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
