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

+(void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelAction:(BOOL)value onViewController:(UIViewController *)viewController{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    if (value) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+(void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonType:(ButtonType)type buttonHandler:(ButtonHandler)handler onViewController:(UIViewController *)viewController {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    
    
    if (type == UIAlertButtonDiscard) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler();
        }]];
    }
    
    [viewController presentViewController:alertController animated:NO completion:nil];
}


@end


