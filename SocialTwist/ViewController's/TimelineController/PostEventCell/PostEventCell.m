//
//  PostEventCell.m
//  SocialTwist
//

#import "PostEventCell.h"

@implementation PostEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.subtitleTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

//-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    [self adjustFrames];
//    return YES;
//}
//
//
//-(void) adjustFrames
//{
//    CGRect textFrame = self.subtitleTextView.frame;
//    textFrame.size.height = self.subtitleTextView.contentSize.height;
//    self.subtitleTextView.frame = textFrame;
//}
//
//- (void)textViewDidChange:(UITextView *)textView {
//    [[TimelineTableController getTableView] beginUpdates];
//    CGFloat paddingForTextView = 40; //Padding varies depending on your cell design
//    self.rowHeight = self.subtitleTextView.contentSize.height + paddingForTextView;
//    [[TimelineTableController getTableView] endUpdates];
//}
@end
