//  Utilities.m
//  loginapp

#import "Utilities.h"

@implementation Utilities

+ (void)setGradientForImage:(UIImageView *)imageView
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = imageView.bounds;
    gradientLayer.colors = @[
                             (id)[[UIColor colorWithRed:(149/255.0) green:(151/255.0) blue:(185/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(155/255.0) green:(186/255.0) blue:(205/255.0) alpha:0.9] CGColor]
                                 ];
    [imageView.layer addSublayer:gradientLayer];
}

+ (UIView *)setGradientForView:(UIView *)tableView
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = tableView.bounds;
    gradientLayer.colors = @[
                             (id)[[UIColor colorWithRed:(149/255.0) green:(151/255.0) blue:(186/255.0) alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:(155/255.0) green:(186/255.0) blue:(205/255.0) alpha:1] CGColor]
                             ];
    
    UIView* view = [[UIView alloc] initWithFrame:tableView.bounds];
    [view.layer insertSublayer:gradientLayer atIndex:0];
    return view;
}


+ (UIView *)getMainUserPin{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image=[UIImage imageNamed:@"logo.png"];
    [view addSubview: imageView];
    return view;
}

@end


