//
//  KeyboardViewController.h
//  KeyboardCustom
//

#import <UIKit/UIKit.h>
#import "KeyboardItemView.h"

@interface KeyboardViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecongnizer;
@property (strong, nonatomic) NSNumber* selectedIndex;

- (IBAction)hadnleDownSwipe:(UISwipeGestureRecognizer *)sender;

+(void)initOnViewController:(UIViewController *) viewController;
+(void)showAnimated:(BOOL) value;
+(void)hideAnimated:(BOOL) value;
+(KeyboardViewController *)getObject;
+(UIImage *)getSelectedIndexImage;
+(NSInteger)getSelectedIndex;
+(BOOL)isHidden;
+(void)enableSwipeGestureRecognizer:(BOOL) value;

@end
