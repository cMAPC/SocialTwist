//  Utilities.m
//  loginapp

#import "Utilities.h"

@implementation Utilities

+ (void)setGradientForImage:(UIImageView *)imageView
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = imageView.bounds;
    gradientLayer.colors = @[
                             (id)[[UIColor colorWithRed:(151/255.0) green:(157/255.0) blue:(183/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(146/255.0) green:(159/255.0) blue:(182/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(145/255.0) green:(170/255.0) blue:(194/255.0) alpha:0.9] CGColor]
                                 ];
    [imageView.layer addSublayer:gradientLayer];
}

+ (UIView *)setGradientForView:(UIView *)tableView
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = tableView.bounds;
    gradientLayer.colors = @[
                             (id)[[UIColor colorWithRed:(151/255.0) green:(157/255.0) blue:(183/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(146/255.0) green:(159/255.0) blue:(182/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(145/255.0) green:(170/255.0) blue:(194/255.0) alpha:0.9] CGColor]
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


