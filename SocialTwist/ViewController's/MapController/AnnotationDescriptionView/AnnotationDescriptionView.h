//
//  AnnotationDescriptionView.h
//  MapModule
//

#import <UIKit/UIKit.h>

@interface AnnotationDescriptionView : UIView

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *subtitleTextView;

@property (weak, nonatomic) IBOutlet UIButton *addAnnotationDescriptionButton;

@end
