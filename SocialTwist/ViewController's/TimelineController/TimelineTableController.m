//
//  TableViewController.m
//  TableViewDynamicSize
//


#import "TimelineTableController.h"

@interface TimelineTableController () {
    NSUInteger correctedHeight;
    
    PostEventCell* prototypePostCell;
    CGFloat postCellHeight;
    
    BOOL isPosting;
}

@end

@implementation TimelineTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableWithCustomCell];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-55.0f, 0.f, 44.f, 0.f)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:2500];
    
    postCellHeight = 130;

    [[EventContent sharedEventContent] getEvents];
//    self.eventCategoryKeyboard = [[KeyboardViewController alloc] init];
    self.eventCategoryKeyboard = [[KeyboardViewController alloc] initOnViewController:self];
}

-(void)viewWillLayoutSubviews{
//    [self.eventCategoryKeyboard setViewController:self];
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PostEventCell" bundle:nil] forCellReuseIdentifier:@"PostCellIndetifier"];
}


#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [EventContent sharedEventContent].eventsArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PostEventCell* postEventCell = [tableView dequeueReusableCellWithIdentifier:@"PostCellIndetifier"];
        postEventCell.subtitleTextView.delegate = self;
        [postEventCell.postButton addTarget:self
                                     action:@selector(postNewEventAction)
                           forControlEvents:UIControlEventTouchUpInside];
        [postEventCell.eventCategoryButton addTarget:self
                                              action:@selector(selectEventCategoryAction)
                                    forControlEvents:UIControlEventTouchUpInside];
        [postEventCell.eventCameraButton addTarget:self
                                            action:@selector(selectEventImageAction)
                                  forControlEvents:UIControlEventTouchUpInside];
        prototypePostCell = postEventCell;
        return postEventCell;
    }
    
    TimelineCellController* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" ];
    //    [cell.cellImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    cell.cellImage.image = [[EventContent sharedEventContent].eventsArray[indexPath.row -1] eventImage];
    cell.profileImageView.image = [[EventContent sharedEventContent].eventsArray[indexPath.row -1] profileImage];
    cell.label.text = [[EventContent sharedEventContent].eventsArray[indexPath.row -1] subtitle];
    
    // like/dislike
    cell.likeButton.tag = indexPath.row;
    [cell.likeButton addTarget:self action:@selector(likeButtonAction:onCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dislikeButton setTitle:[NSString stringWithFormat:@"%d Dislikes", 12] forState:UIControlStateNormal];
    [cell.likeButton setTitle:[NSString stringWithFormat:@"%ld Likes", (long)cell.likeCount] forState:UIControlStateNormal];
    
    [self adjustImageHeightForCell:cell];
    [self adjustStringFormat:cell];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return postCellHeight;
    }
    return UITableViewAutomaticDimension;
}


#pragma mark - PostEventCell Action
-(void)postNewEventAction{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [prototypePostCell.subtitleTextView.text stringByTrimmingCharactersInSet:charSet];
    
//    if (prototypePostCell.eventImag.image != nil ||
//        (![prototypePostCell.subtitleTextView.text isEqualToString:@"What's new?"] && ![trimmedString isEqualToString:@""])
//        ) {
//   
//    }
//    else
//    {
//        [Utilities showAlertControllerWithTitle:@"Invalid input" message:@"You have entered an invalid event description or image" onViewController:self];
//    }
    
    if (prototypePostCell.eventImag.image == nil &&
        ([prototypePostCell.subtitleTextView.text isEqualToString:@"What's new?"] || [trimmedString isEqualToString:@""])
        ){
        [Utilities showAlertControllerWithTitle:@"Invalid input" message:@"You have entered an invalid event description or image" cancelAction:NO onViewController:self];
    }
    else if (([prototypePostCell.eventCategoryButton.currentImage isEqual:[UIImage imageNamed:@"marker"]])){
        [Utilities showAlertControllerWithTitle:@"Invalid category" message:@"You must enter event category" cancelAction:NO onViewController:self];
    }
    else
    {
        [[EventContent sharedEventContent] addNewEventWithTitle:@""
                                                       subtitle:prototypePostCell.subtitleTextView.text
                                                    coordinates:CLLocationCoordinate2DMake(0, 0)
                                                  eventCategory:[self.eventCategoryKeyboard selectedIndex].integerValue
                                                   profileImage:[UIImage imageNamed:@"imageRight"]
                                                     eventImage:prototypePostCell.eventImag.image];
        
        [self.tableView beginUpdates];
        [self restoreEmptyPostCell];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
    }
    
    isPosting = NO;
}

-(BOOL)isPosting {
    return isPosting;
}

-(void)selectEventCategoryAction{
    if ([self.eventCategoryKeyboard isHidden]) {
        [self.eventCategoryKeyboard showAnimated:YES];
    }
    else {
        [self.eventCategoryKeyboard hideAnimated:YES];
    }
}

-(void)selectEventImageAction{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    prototypePostCell.eventImageViewHeighLayoutConstraint.constant = 60;
    postCellHeight = 180;
    prototypePostCell.eventImag.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self adjustHeightForPostEventCell];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    isPosting = YES;
}

#pragma mark - Custom Keyboard KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"Observer");
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [prototypePostCell.eventCategoryButton setImage:[self.eventCategoryKeyboard selectedIndexImage]
                                                           forState:UIControlStateNormal];
        isPosting = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.eventCategoryKeyboard hideAnimated:YES];
        });
        
    }
}

-(void)restoreEmptyPostCell {
//    [prototypePostCell.eventCategoryButton setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
//    [prototypePostCell.eventImag setImage:nil];
//    prototypePostCell.eventImageViewHeighLayoutConstraint.constant = 2;
    
//    [self setPlaceholderOnTextView:prototypePostCell.subtitleTextView];
    
//    [self adjustHeightForPostEventCell];
//    [prototypePostCell.subtitleTextView resignFirstResponder];
    
//    [KeyboardViewController hideAnimated:YES];
//    isPosting = NO;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //Do background work
        isPosting = NO;
//        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
//            [prototypePostCell.subtitleTextView resignFirstResponder];
            [self.view endEditing:YES];
            [self.eventCategoryKeyboard hideAnimated:YES];
    
            [prototypePostCell.eventCategoryButton setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
            [prototypePostCell.eventImag setImage:nil];
            prototypePostCell.eventImageViewHeighLayoutConstraint.constant = 2;
            [self setPlaceholderOnTextView:prototypePostCell.subtitleTextView];
            [self adjustHeightForPostEventCell];
}

-(void)setPlaceholderOnTextView:(UITextView *)textView {
    [textView setText:@"What's new?"];
    [textView setTextColor:[UIColor colorWithRed:169/255.0
                                           green:169/255.0
                                            blue:169/255.0
                                           alpha:1]];
}

#pragma mark - EventCell Action's
-(void)likeButtonAction:(UIButton *) sender onCell:(TimelineCellController *) cell{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    TimelineCellController* celll = [self.tableView cellForRowAtIndexPath:indexPath];
    
    celll.likeCount ++;
    celll.dislikeCount++;
    
    [self adjustButtonContentFormatForCell:celll];
    [self.tableView reloadData];
    NSLog(@"button clicked %ld %@", (long)sender.tag, celll.statusLabel);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextViewDelegate
//-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    [self adjustTextViewFrameForPostCell];
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView {
    [self adjustTextViewFrameForPostCell];
    [self adjustHeightForPostEventCell];
    [prototypePostCell.subtitleTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    
    isPosting = YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"What's new?"]) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    [textView becomeFirstResponder];
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [self setPlaceholderOnTextView:textView];
    }
    [textView resignFirstResponder];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



#pragma mark - Adjustments
-(void)adjustTextViewFrameForPostCell {
    CGRect textFrame = prototypePostCell.subtitleTextView.frame;
    textFrame.size.height = prototypePostCell.subtitleTextView.contentSize.height;
    prototypePostCell.subtitleTextView.frame = textFrame;
}
-(void)adjustHeightForPostEventCell {
    [self.tableView beginUpdates];
    CGFloat paddingForTextView;
    if (prototypePostCell.eventImag.image != nil) {
        paddingForTextView = 155;
    }
    else {
        paddingForTextView = 95; //Padding varies depending on your cell design
    }
    postCellHeight = prototypePostCell.subtitleTextView.contentSize.height + paddingForTextView;
    [self.tableView endUpdates];
}

-(void)adjustButtonContentFormatForCell:(TimelineCellController *) cell {
    [cell.dislikeButton setImage:[UIImage imageNamed:@"dislike-icon-hightlighted"] forState:UIControlStateNormal];
    [cell.dislikeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cell.likeButton setImage:[UIImage imageNamed:@"like-icon-higtlighted"] forState:UIControlStateNormal];
    [cell.likeButton setTitleColor:[UIColor colorWithRed:(155/255.0) green:186/255.0 blue:205/255.0 alpha:1.0]
                          forState:UIControlStateNormal];
}

-(void)adjustImageHeightForCell:(TimelineCellController *) cell {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [cell.cellImage removeConstraint: cell.cellImage.constraints.lastObject];
    if (cell.cellImage.image != nil) {
        if(cell.cellImage.image.size.width >= width) {
            correctedHeight = (width - 40)/ cell.cellImage.image.size.width * cell.cellImage.image.size.height;
            //            [cell.cellImage setTranslatesAutoresizingMaskIntoConstraints:NO];
            //            [cell.cellImage removeConstraint: cell.cellImage.constraints.lastObject];
            [cell.cellImage addConstraint:[NSLayoutConstraint constraintWithItem:cell.cellImage
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:correctedHeight]];
        }
    }
    
    else {
        [cell.cellImage addConstraint:[NSLayoutConstraint constraintWithItem:cell.cellImage
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:0]];
    }
}

-(void)adjustStringFormat:(TimelineCellController *) cell {
        
        NSString* name = @"Spinu Marcel";
        NSString* at = @"at";
        NSString* place = @"Chisinau";
    
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]
                                                       initWithString:[NSString stringWithFormat:@"%@ %@    %@",name,at,place]];
        
        NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
        [textAttachment setImage:[UIImage imageNamed:@"pin"]];
        
        CGFloat scaleFactor = textAttachment.image.size.height / 9;
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage
                                                   scale:scaleFactor orientation:UIImageOrientationUp];

        
        [mutableAttributedString beginEditing];
        
        [mutableAttributedString addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:13]
                                        range:NSMakeRange(0,name.length)];
        
        
        NSDictionary *atAtributeDictionary = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                NSForegroundColorAttributeName:[UIColor colorWithRed:(169/255.0)
                                                                                               green:(169/255.0)
                                                                                                blue:(169/255.0)
                                                                                               alpha:1]
                                               };
        [mutableAttributedString addAttributes:atAtributeDictionary
                                  range:NSMakeRange(name.length+1,at.length)];
        
        
        NSDictionary *placeAtributeDictionary = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                                   NSForegroundColorAttributeName:[UIColor colorWithRed:(155/255.0)
                                                                                                  green:(186/255.0)
                                                                                                   blue:(205/255.0)
                                                                                                  alpha:1]
                                                  };
        
        [mutableAttributedString addAttributes:placeAtributeDictionary
                                         range:NSMakeRange(name.length + 7, place.length)];
        
        [mutableAttributedString endEditing];
        
        
        NSAttributedString* attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(name.length + 5, 1)
                                     withAttributedString:attributedString];
    
        cell.statusLabel.attributedText = mutableAttributedString;
}


@end
