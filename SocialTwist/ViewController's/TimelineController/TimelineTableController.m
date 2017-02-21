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
