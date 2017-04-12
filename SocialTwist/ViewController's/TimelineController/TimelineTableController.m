//
//  TableViewController.m
//  TableViewDynamicSize
//


#import "TimelineTableController.h"

@interface TimelineTableController () <UITextViewDelegate> {
    NSUInteger correctedHeight;
    
    PostEventCell* prototypeCell;
    CGFloat rowHeight;
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
    
    rowHeight = 130;
    
}



-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PostEventCell" bundle:nil] forCellReuseIdentifier:@"PostCellIndetifier"];
}


#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PostEventCell* postEventCell = [tableView dequeueReusableCellWithIdentifier:@"PostCellIndetifier"];
        postEventCell.subtitleTextView.delegate = self;
        prototypeCell = postEventCell;
        return postEventCell;
    }
    
    TimelineCellController* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" ];
    
    cell.cellImage.image = [UIImage imageNamed:@"imageLeft"];
    cell.profileImageView.image = [UIImage imageNamed:@"imageRight"];
    cell.label.text = @"\rSunset in Rome is Wonderful\r";
    
    int likes = 11;
    int disklikes = 12;
    
    cell.likeButton.tag = indexPath.row;
    [cell.likeButton addTarget:self action:@selector(likeButtonAction:onCell:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.dislikeButton setTitle:[NSString stringWithFormat:@"%d Dislikes", disklikes] forState:UIControlStateNormal];
    [cell.likeButton setTitle:[NSString stringWithFormat:@"%ld Likes", cell.likeCount] forState:UIControlStateNormal];
    
    
    
    [self adjustImageHeightForCell:cell];
    [self adjustStringFormat:cell];
    
    return cell;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return rowHeight;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}



-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (prototypeCell.subtitleTextView.frame.size.height < _textView.contentSize.height) {
        [self adjustFrames];
    }
    
    return YES;
}


-(void) adjustFrames
{
    CGRect textFrame = prototypeCell.subtitleTextView.frame;
    textFrame.size.height = prototypeCell.subtitleTextView.contentSize.height;
    prototypeCell.subtitleTextView.frame = textFrame;
    [self updateViewConstraints];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (prototypeCell.subtitleTextView.frame.size.height < textView.contentSize.height) {
        [self.tableView beginUpdates];
        CGFloat paddingForTextView = 90; //Padding varies depending on your cell design
        rowHeight = prototypeCell.subtitleTextView.contentSize.height + paddingForTextView;
        [self.tableView endUpdates];
    }
   
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

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
}

#pragma mark - Adjustments
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
