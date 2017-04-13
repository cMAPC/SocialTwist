//
//  TableViewController.m
//  TableViewDynamicSize
//


#import "TimelineTableController.h"

@interface TimelineTableController () {
    NSUInteger correctedHeight;
    
    PostEventCell* prototypePostCell;
    CGFloat postCellHeight;
    
    EventContent* eventContent;
    CLLocationManager* locationManager;
}

@end

@implementation TimelineTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableWithCustomCell];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(10.f, 0.f, 44.f, 0.f)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:500];
    
    postCellHeight = 130;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    eventContent = [[EventContent alloc] init];
    [eventContent getEvents];
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [KeyboardViewController initOnViewController:self];
    [KeyboardViewController enableSwipeGestureRecognizer:YES];
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PostEventCell" bundle:nil] forCellReuseIdentifier:@"PostCellIndetifier"];
}

#pragma mark - PostEventCell Action
-(void)postNewEventAction{
    [eventContent addNewEventWithTitle:@""
                              subtitle:prototypePostCell.subtitleTextView.text
                           coordinates:locationManager.location.coordinate
                         eventCategory:[KeyboardViewController getSelectedIndex]
                          profileImage:[UIImage imageNamed:@"imageRight"]
                            eventImage:[UIImage imageNamed:@"imageLeft"]];
    
    [self.tableView beginUpdates];
    [self restoreEmptyPostCell];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)selectEventCategoryAction{
    if ([KeyboardViewController isHidden]) {
        [KeyboardViewController showAnimated:YES];
    }
    else {
        [KeyboardViewController hideAnimated:YES];
    }
}
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"Observer");
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [prototypePostCell.eventCategoryButton setImage:[KeyboardViewController getSelectedIndexImage]
                                                           forState:UIControlStateNormal];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KeyboardViewController hideAnimated:YES];
        });
        
    }
}


#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventContent.eventsArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PostEventCell* postEventCell = [tableView dequeueReusableCellWithIdentifier:@"PostCellIndetifier"];
        postEventCell.subtitleTextView.delegate = self;
        [postEventCell.postButton addTarget:self action:@selector(postNewEventAction) forControlEvents:UIControlEventTouchUpInside];
        [postEventCell.eventCategoryButton addTarget:self action:@selector(selectEventCategoryAction) forControlEvents:UIControlEventTouchUpInside];
        prototypePostCell = postEventCell;
        return postEventCell;
    }
    
    TimelineCellController* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" ];
    
//    cell.cellImage.image = [UIImage imageNamed:@"imageLeft"];
//    cell.profileImageView.image = [UIImage imageNamed:@"imageRight"];
//    cell.label.text = @"\rSunset in Rome is Wonderful\r";
    
    cell.cellImage.image = [eventContent.eventsArray[indexPath.row -1] eventImage];
    cell.profileImageView.image = [eventContent.eventsArray[indexPath.row -1] profileImage];
    cell.label.text = [eventContent.eventsArray[indexPath.row -1] subtitle];

//    int likes = 11;
    int disklikes = 12;
    
    cell.likeButton.tag = indexPath.row;
    [cell.likeButton addTarget:self action:@selector(likeButtonAction:onCell:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.dislikeButton setTitle:[NSString stringWithFormat:@"%d Dislikes", disklikes] forState:UIControlStateNormal];
    [cell.likeButton setTitle:[NSString stringWithFormat:@"%ld Likes", cell.likeCount] forState:UIControlStateNormal];
    
    
    
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

#pragma mark - Actions
-(void)likeButtonAction:(UIButton *) sender onCell:(TimelineCellController *) cell{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    TimelineCellController* celll = [self.tableView cellForRowAtIndexPath:indexPath];
    
    celll.likeCount ++;
    celll.dislikeCount++;
    
    [self adjustButtonContentFormatForCell:celll];
    [self.tableView reloadData];
    NSLog(@"button clicked %ld %@", sender.tag, celll.statusLabel);
}

-(void)restoreEmptyPostCell{
    [prototypePostCell.eventCategoryButton setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
    [self setPlaceholderOnTextView:prototypePostCell.subtitleTextView];
    [self adjustHeightForPostEventCell];
    
    [prototypePostCell.subtitleTextView resignFirstResponder];
}

-(void)setPlaceholderOnTextView:(UITextView *)textView {
    [textView setText:@"What's new?"];
    [textView setTextColor:[UIColor colorWithRed:169/255.0
                                           green:169/255.0
                                            blue:169/255.0
                                           alpha:1]];
}

#pragma mark - Adjustments
-(void)adjustTextViewFrameForPostCell {
    CGRect textFrame = prototypePostCell.subtitleTextView.frame;
    textFrame.size.height = prototypePostCell.subtitleTextView.contentSize.height;
    prototypePostCell.subtitleTextView.frame = textFrame;
}
-(void)adjustHeightForPostEventCell {
    [self.tableView beginUpdates];
    CGFloat paddingForTextView = 95; //Padding varies depending on your cell design
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
    if(cell.cellImage.image.size.width >= width) {
        
        correctedHeight = (width - 40)/ cell.cellImage.image.size.width * cell.cellImage.image.size.height;
//        [cell.cellImage removeConstraint: cell.cellImage.constraints.lastObject];
        [cell.cellImage addConstraint:[NSLayoutConstraint constraintWithItem:cell.cellImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: correctedHeight]];
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
