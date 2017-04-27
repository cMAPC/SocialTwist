//
//  KeyboardViewController.m
//  KeyboardCustom
//

#import "KeyboardViewController.h"

@interface KeyboardViewController () {
    NSArray *titleArray;
    NSArray *imageArray;
    
    UIViewController* destinationViewController;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* verticalLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* horizontalLayoutConstraint;

@end

#pragma mark - Global's
//KeyboardViewController* obj;
//NSInteger destinationHeight;
//UIImage* selectedImageAtIndex;
//NSInteger selectedIndex;
//BOOL isHidden = YES;
//BOOL isEnabled = YES;
//UIView* destinationView;

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = @[ @"Eating",
                    @"Sport",
                    @"Coffe",
                    @"Drink",
                    @"Thinking",
                    @"Traveling",
                    @"Watching",
                    @"Celebrating",
                    @"Celebrating",
                    @"Meeting",
                    @"Listen",
                    @"Shopping",
                    @"Reading",
                    @"Supporting",
                    @"Attending",
                    @"Making",
                    @"Sad",
                    @"Happy",
                    @"Loved",
                    @"Amused",
                    @"Wonderful",
                    @"Energized",
                    @"Alone",
                    @"Hungry"];
    
    imageArray = @[ @"Eating",
                    @"Sport",
                    @"Coffee",
                    @"Drink",
                    @"Thinking",
                    @"Traveling",
                    @"Watching",
                    @"Celebrating",
                    @"Celebrating1",
                    @"Meeting",
                    @"Listen",
                    @"Shopping",
                    @"Reading",
                    @"Supporting",
                    @"Attending",
                    @"Making",
                    @"Sad",
                    @"Happy",
                    @"Loved",
                    @"Amused",
                    @"Wonderful",
                    @"Energized",
                    @"Alone",
                    @"Hungry"];
    
    [self setIsHidden:YES];
    [self.swipeGestureRecongnizer setEnabled:YES];
    [self observeKeyboardNotifications];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"KeyboardItemView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.horizontalLayoutConstraint setConstant:[UIScreen mainScreen].bounds.size.width];
    
    [self addObserver:destinationViewController
           forKeyPath:@"selectedIndex"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

#pragma mark - Keyboard Notifications
-(void)observeKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification {
    self.view.frame = CGRectMake(0,
                                 destinationViewController.view.frame.size.height,
                                 [UIScreen mainScreen].bounds.size.width,
                                 self.collectionView.frame.size.height);
    [self setIsHidden:YES];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [titleArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KeyboardItemView* itemKeyboard = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    itemKeyboard.itemNameLabel.text = titleArray[indexPath.row];
    itemKeyboard.itemImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    
    self.verticalLayoutConstraint.constant = self.collectionView.contentSize.height;
    
    self.view.frame = CGRectMake(0,
                                 [UIScreen mainScreen].bounds.size.height,
                                 [UIScreen mainScreen].bounds.size.width,
                                 self.collectionView.frame.size.height);
    
    return itemKeyboard;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [self performAnimationOnView:cell duration:0.5f delay:0.f];
    [self setSelectedIndexImage:[UIImage imageNamed:imageArray[indexPath.row]]];
    [self setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"selectedIndex"];
}


#pragma mark - Animations
-(void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateKeyframesWithDuration:duration/3 delay:delay options:0 animations:^{
        // End
        view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
            // End
            view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
                // End
                view.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

#pragma mark - Actions
- (IBAction)hadnleDownSwipe:(UISwipeGestureRecognizer *)sender {
    [self hideAnimated:YES];
}

-(void)showAnimated:(BOOL) value{
    [destinationViewController.view endEditing:YES];
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self view].frame = CGRectMake(0,
                                      destinationViewController.view.frame.size.height - self.collectionView.frame.size.height,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [self view].frame.size.height);
    } completion:^(BOOL finished) {
        [self setIsHidden:NO];
    }];
}

-(void)hideAnimated:(BOOL) value {
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self view].frame = CGRectMake(0,
                                      destinationViewController.view.frame.size.height,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [self view].frame.size.height);
    } completion:^(BOOL finished) {
        [self setIsHidden:YES];
    }];
}

#pragma mark - Initialization
-(void)setViewController:(UIViewController *) viewController {
    destinationViewController = viewController;
    [viewController addChildViewController:self];
    [viewController.view addSubview:[self view]];
    [self didMoveToParentViewController:viewController];
}

#pragma mark - Dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:destinationViewController forKeyPath:@"selectedIndex"];
}
































//-(void)viewDidAppear:(BOOL)animated {
////    self.verticalLayoutConstraint.constant = self.collectionView.contentSize.height;
//    [self.collectionView reloadData];
//}
//
//#pragma mark - Keyboard Notifications
//-(void)observeKeyboardNotifications{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//-(void)keyboardWillShow:(NSNotification *)notification {
//    self.view.frame = CGRectMake(0,
//                                 destinationHeight,
//                                 [UIScreen mainScreen].bounds.size.width,
//                                 self.collectionView.frame.size.height);
//    isHidden = YES;
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification {
//
//}
//
//
//#pragma mark - Actions
//- (IBAction)hadnleDownSwipe:(UISwipeGestureRecognizer *)sender {
//    [KeyboardViewController hideAnimated:YES];
//}
//
//#pragma mark - UICollectionViewDataSource
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [titleArray count];
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    KeyboardItemView* itemKeyboard = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    itemKeyboard.itemNameLabel.text = titleArray[indexPath.row];
//    itemKeyboard.itemImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
//    
////    self.horizontalLayoutConstraint.constant = [UIScreen mainScreen].bounds.size.width;
//    self.verticalLayoutConstraint.constant = self.collectionView.contentSize.height;
//
//    self.view.frame = CGRectMake(0,
//               [UIScreen mainScreen].bounds.size.height,
//               [UIScreen mainScreen].bounds.size.width,
//               self.collectionView.frame.size.height);
//
//    return itemKeyboard;
//}
//
//#pragma mark - UICollectionViewDelegate
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [self performAnimationOnView:cell duration:0.5f delay:0.f];
//    
//    selectedImageAtIndex = [UIImage imageNamed:imageArray[indexPath.row]];
//    selectedIndex = indexPath.row;
//    [obj setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"selectedIndex"];
//    
//}
//
//
//#pragma mark - Animations
//-(void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
//    // Start
//    view.transform = CGAffineTransformMakeScale(1, 1);
//    [UIView animateKeyframesWithDuration:duration/3 delay:delay options:0 animations:^{
//        // End
//        view.transform = CGAffineTransformMakeScale(1.3, 1.3);
//    } completion:^(BOOL finished) {
//        [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
//            // End
//            view.transform = CGAffineTransformMakeScale(0.9, 0.9);
//        } completion:^(BOOL finished) {
//            [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
//                // End
//                view.transform = CGAffineTransformMakeScale(1, 1);
//            } completion:^(BOOL finished) {
//                
//            }];
//        }];
//    }];
//}
//
//+(void)showAnimated:(BOOL) value{
//    [destinationView endEditing:YES];
//    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [obj view].frame = CGRectMake(0,
//                                      destinationHeight - obj.collectionView.frame.size.height,
//                                      [UIScreen mainScreen].bounds.size.width,
//                                      [obj view].frame.size.height);
//    } completion:^(BOOL finished) {
//        isHidden = NO;
//    }];
//}
//
//+(void)hideAnimated:(BOOL) value {
//    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [obj view].frame = CGRectMake(0,
//                                      destinationHeight,
//                                      [UIScreen mainScreen].bounds.size.width,
//                                      [obj view].frame.size.height);
//    } completion:^(BOOL finished) {
//        isHidden = YES;
//    }];
//}
//
//#pragma mark - Initialization
//+(void)initOnViewController:(UIViewController *) viewController {
//    destinationHeight = viewController.view.frame.size.height;
//    destinationView = viewController.view;
//    
//    obj = [[KeyboardViewController alloc] init];
//    [viewController addChildViewController:obj];
//    [viewController.view addSubview:[obj view]];
//    [obj didMoveToParentViewController:viewController];
//    
//    [obj addObserver:viewController
//          forKeyPath:@"selectedIndex"
//             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//             context:nil];
//}
//
//+(BOOL)isHidden {
//    return isHidden;
//}
//
//+(void)enableSwipeGestureRecognizer:(BOOL) value {
//    isEnabled = value;
//}
//
//+(KeyboardViewController *)getObject {
//    return obj;
//}
//
//+(UIImage *)getSelectedIndexImage{
//    return selectedImageAtIndex;
//}
//
//+(NSInteger)getSelectedIndex{
//    return selectedIndex;
//}

@end
