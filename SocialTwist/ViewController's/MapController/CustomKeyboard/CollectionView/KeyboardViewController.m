//
//  KeyboardViewController.m
//  KeyboardCustom
//

#import "KeyboardViewController.h"

@interface KeyboardViewController () {
    NSArray *titleArray;
    NSArray *imageArray;
    
    UIViewController* parentViewController;
    
    UIView* parentView;
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
    
    [self addObserver:parentViewController
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
                                 parentView.frame.size.height,
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
    
    if ([self.delegate respondsToSelector:@selector(didTapKeyboard:item:itemImage:)]) {
//        [self.delegate didTapKeyboard:indexPath.row];
        [self.delegate didTapKeyboard:self item:indexPath.row itemImage:self.selectedIndexImage];
    }
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
    [parentViewController.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
//    NSLog(@"screen height %f", [UIScreen mainScreen].bounds.size.height);
//    NSLog(@"collection height %f", self.collectionView.frame.size.height);
//    NSLog(@"trash view height %f", parentView.frame.size.height - self.collectionView.frame.size.height);
    
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self view].frame = CGRectMake(0,
                                       parentView.frame.size.height - self.collectionView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       [self view].frame.size.height);
    } completion:^(BOOL finished) {
        [self setIsHidden:NO];
    }];
}

-(void)hideAnimated:(BOOL) value {
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self view].frame = CGRectMake(0,
                                       parentView.frame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       [self view].frame.size.height);
    } completion:^(BOOL finished) {
        [self setIsHidden:YES];
    }];
}

#pragma mark - Initialization
-(instancetype)initOnViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            parentViewController = viewController;
            parentView = [[UIView alloc] initWithFrame:CGRectMake(viewController.view.frame.origin.x,
                                                                 viewController.view.frame.origin.y,
                                                                 viewController.view.frame.size.width,
                                                                 viewController.view.frame.size.height)];
            [viewController addChildViewController:self];
            [viewController.view addSubview:[self view]];
            [self didMoveToParentViewController:viewController];
        });
        
    }
    return self;
}

-(void)addToView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        parentView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x,
                                                             view.frame.origin.y,
                                                             view.frame.size.width,
                                                             view.frame.size.height)];
        [view addSubview:[self view]];
    });
}

#pragma mark - Dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:parentViewController forKeyPath:@"selectedIndex"];
}


#pragma mark - TrashUntil
/*
-(void)setViewController:(UIViewController *) viewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        destinationViewController = viewController;
        [viewController addChildViewController:self];
        [viewController.view addSubview:[self view]];
        [self didMoveToParentViewController:viewController];
    });
    
}

-(void)setViewController:(UIViewController *) viewController onView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        destinationViewController = viewController;
        parentView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x,
                                                             view.frame.origin.y,
                                                             view.frame.size.width,
                                                             view.frame.size.height)];
        [viewController addChildViewController:self];
        [view addSubview:[self view]];
        [self didMoveToParentViewController:viewController];
    });
}
*/



























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
