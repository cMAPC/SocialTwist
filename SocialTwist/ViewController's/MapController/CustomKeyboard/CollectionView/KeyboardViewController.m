//
//  KeyboardViewController.m
//  KeyboardCustom
//

#import "KeyboardViewController.h"

@interface KeyboardViewController () {
    NSArray *titleArray;
    NSArray *imageArray;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* verticalLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* horizontalLayoutConstraint;

@end

#pragma mark - Global's
KeyboardViewController* obj;
NSInteger destinationHeight;
UIImage* selectedImageAtIndex;
NSInteger selectedIndex;
BOOL isHidden = YES;
BOOL isEnabled = YES;

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
    
    [self.swipeGestureRecongnizer setEnabled:isEnabled];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KeyboardItemView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}


-(void)viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}
#pragma mark - Actions
- (IBAction)hadnleDownSwipe:(UISwipeGestureRecognizer *)sender {
    [KeyboardViewController hideAnimated:YES];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [titleArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KeyboardItemView* itemKeyboard = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    itemKeyboard.itemNameLabel.text = titleArray[indexPath.row];
    itemKeyboard.itemImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
//    itemKeyboard.itemImageView.image = [UIImage imageNamed:@"test"];
    
//    self.collectionView.frame = CGRectMake(0,
//                                           [UIScreen mainScreen].bounds.size.height - self.collectionView.frame.size.height,
//                                           [UIScreen mainScreen].bounds.size.width,
//                                           self.collectionView.frame.size.height);
//    
//
//    self.view.frame = CGRectMake(0,
//                                     [UIScreen mainScreen].bounds.size.height - self.collectionView.frame.size.height,
//                                     [UIScreen mainScreen].bounds.size.width,
//                                     self.collectionView.frame.size.height);
    self.view.frame = CGRectMake(0,
               destinationHeight,
               [UIScreen mainScreen].bounds.size.width,
               self.collectionView.frame.size.height + 20);
    
    self.horizontalLayoutConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    self.verticalLayoutConstraint.constant = self.collectionView.contentSize.height;
    
    return itemKeyboard;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self performAnimationOnView:cell duration:0.5f delay:0.f];
    
    selectedImageAtIndex = [UIImage imageNamed:imageArray[indexPath.row]];
    selectedIndex = indexPath.row;
    [obj setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"selectedIndex"];
    
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

+(void)showAnimated:(BOOL) value{
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [obj view].frame = CGRectMake(0,
                                      destinationHeight - [obj view].frame.size.height - 20,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [obj view].frame.size.height + 20);
    } completion:^(BOOL finished) {
        isHidden = NO;
    }];
}

+(void)hideAnimated:(BOOL) value {
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [obj view].frame = CGRectMake(0,
                                      destinationHeight + 20,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [obj view].frame.size.height - 20);
    } completion:^(BOOL finished) {
        isHidden = YES;
    }];
}



#pragma mark - Initialization
+(void)initOnViewController:(UIViewController *) viewController {
    destinationHeight = viewController.view.frame.size.height;
    
    obj = [[KeyboardViewController alloc] init];
    [viewController addChildViewController:obj];
    [viewController.view addSubview:[obj view]];
    [obj didMoveToParentViewController:viewController];
    
    [obj addObserver:viewController
          forKeyPath:@"selectedIndex"
             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
             context:nil];
}


+(BOOL)isHidden {
    return isHidden;
}

+(void)enableSwipeGestureRecognizer:(BOOL) value {
    isEnabled = value;
}

+(KeyboardViewController *)getObject {
    return obj;
}

+(UIImage *)getSelectedIndexImage{
    return selectedImageAtIndex;
}

+(NSInteger)getSelectedIndex{
    return selectedIndex;
}

@end
