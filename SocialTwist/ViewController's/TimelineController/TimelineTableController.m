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
    
    cell.profileName.text = @"Radu Spataru";
    [cell.eventPlace setFont:[UIFont systemFontOfSize:6]];
    cell.eventPlace.text = @"Piazza del Popolo";
   
    [self adjustImageHeightForCell:cell];
    
    return cell;
}

#pragma mark - UITableViewDelegate



#pragma mark - ImageConstrains

-(void)adjustImageHeightForCell:(TimelineCellController *) cell {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if(cell.cellImage.image.size.width >= width) {
        
        correctedHeight = (width - 40)/ cell.cellImage.image.size.width * cell.cellImage.image.size.height;
//        [cell.cellImage removeConstraint: cell.cellImage.constraints.lastObject];
        [cell.cellImage addConstraint:[NSLayoutConstraint constraintWithItem:cell.cellImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: correctedHeight]];
    }
}


@end
