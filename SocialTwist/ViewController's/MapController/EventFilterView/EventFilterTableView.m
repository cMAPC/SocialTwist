//
//  EventFilterTableView.m
//  SocialTwist
//
//  Created by Marcel  on 5/1/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "EventFilterTableView.h"

@interface EventFilterTableView ()

@end

@implementation EventFilterTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"EventFilterCell" bundle:nil] forCellReuseIdentifier:@"EventFilterCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 24;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventFilterCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EventFilterCell"];
    cell.switchControl.tag = indexPath.row;
    [cell.switchControl addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
    [cell setNeedsDisplay];
    [cell setNeedsLayout];
    return cell;
}

-(void)handleSwitch:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated {
   [self.tableView reloadData];
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
    [super viewWillAppear:YES];
}

-(void)viewDidLayoutSubviews {
    [self.tableView reloadData];
    [super viewDidLayoutSubviews];
}
@end
