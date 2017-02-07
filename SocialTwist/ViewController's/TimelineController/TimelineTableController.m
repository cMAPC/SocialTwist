//
//  TableViewController.m
//  TableViewDynamicSize
//


#import "TimelineTableController.h"

@interface TimelineTableController () {
    NSUInteger correctedHeight;
}

@end

@implementation TimelineTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableWithCustomCell];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-55.f, 0.f, 44.f, 0.f)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:500];
    
}



-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
}


#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineCellController* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" ];
    
    cell.cellImage.image = [UIImage imageNamed:@"imageLeft"];
    cell.profileImageView.image = [UIImage imageNamed:@"imageRight"];
    cell.label.text = @"Sunset in Rome is Wonderful";
    
    [self adjustImageHeightForCell:cell];
    
    [self adjustStringFormat:cell];
    
//    cell.userNameAndPlaceTextView.attributedText = mutableAttributedString;
    
    return cell;
}

#pragma mark - UITableViewDelegate



#pragma mark - Adjustments

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
    NSString* place = @"Chisinau, str.Alba-Iulia";
    
    //    [cell.userNameAndPlaceTextView setContentInset:UIEdgeInsetsMake(8, -4, -8, 0)];
    
    
    
    NSMutableAttributedString* mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:
                                                          [NSString stringWithFormat:@"%@ %@    %@", name, at, place]];
    [mutableAttributedString beginEditing];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(0, name.length)];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:13]
                                    range:NSMakeRange(name.length + 1, 2)];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(name.length + 7, place.length)];
    
    [mutableAttributedString endEditing];
    
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    [attachment setImage:[UIImage imageNamed:@"pin"]];
    
    CGFloat scaleFactor = attachment.image.size.height / 9;
    attachment.image = [UIImage imageWithCGImage:attachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    
    NSAttributedString* attributedString = [NSAttributedString attributedStringWithAttachment:attachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(name.length + 5, 1) withAttributedString:attributedString];
    
    cell.userNameAndPlaceTextView.attributedText = mutableAttributedString;
}


@end
