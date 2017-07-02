//
//  KeyboardViewController.h
//  KeyboardCustom
//

#import <UIKit/UIKit.h>
#import "KeyboardItemView.h"

@protocol KeyboardControllerDelegate;


@interface KeyboardViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecongnizer;

@property (strong, nonatomic) NSNumber* selectedIndex;
@property (strong, nonatomic) UIImage* selectedIndexImage;
@property (assign, nonatomic) BOOL isHidden;

- (IBAction)hadnleDownSwipe:(UISwipeGestureRecognizer *)sender;
- (void)showAnimated:(BOOL) value;
- (void)hideAnimated:(BOOL) value;

- (instancetype)initOnViewController:(UIViewController *)viewController;
- (void)addToView:(UIView *)view;

@property (weak, nonatomic) IBOutlet id <KeyboardControllerDelegate> delegate;

/*Trash until
- (void)setViewController:(UIViewController *) viewController;
- (void)setViewController:(UIViewController *) viewController onView:(UIView *)view;
*/
 
 
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecongnizer;
//@property (strong, nonatomic) NSNumber* selectedIndex;
//- (IBAction)hadnleDownSwipe:(UISwipeGestureRecognizer *)sender;
//
//+(void)initOnViewController:(UIViewController *) viewController;
//+(void)showAnimated:(BOOL) value;
//+(void)hideAnimated:(BOOL) value;
//+(KeyboardViewController *)getObject;
//+(UIImage *)getSelectedIndexImage;
//+(NSInteger)getSelectedIndex;
//+(BOOL)isHidden;
//+(void)enableSwipeGestureRecognizer:(BOOL) value;

@end

@protocol KeyboardControllerDelegate <NSObject>
@optional
-(void)didTapKeyboard:(KeyboardViewController *)keyboard item:(NSInteger)item itemImage:(UIImage *)image;
@end
