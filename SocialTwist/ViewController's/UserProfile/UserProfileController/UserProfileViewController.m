//
//  UserProfileViewController.m
//  SocialTwist
//

#import "UserProfileViewController.h"
#import "UserProfileCell.h"
#import "GalleryViewController.h"
#import "EventCell.h"
#import "EventContent.h"
#import <DLImageLoader.h>
#import "RequestManager.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
{
    NSUInteger correctedHeight;
    UserProfileCell * prototypeCell;
    NSInteger selectRow;
    NSInteger gestureTapped;
    UserData* userData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.nameLabel setText:self.name];
    [self initTableWithCustomCell];
    [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setEstimatedRowHeight:10500];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    [[RequestManager sharedManager]getUserWithID:self.userID
                                         success:^(id responseObject) {
                                             userData = [responseObject copy];
                                             [self.tableView reloadData];
                                         } fail:^(NSError *error, NSInteger statusCode) {
                                             
                                         }];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil] forCellReuseIdentifier:@"UserProfileCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0){
        UserProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",
                                 userData.firstName,
                                 userData.lastName
                                 ]];
  
        [cell.ageAndLocationLabel setText:[NSString stringWithFormat:@"%ld years old",
                                           (long)[self getAgeFromDate:userData.birthday]
                                           ]];
//        [[DLImageLoader sharedInstance] imageFromUrl:userData.picture
//                                           completed:^(NSError *error, UIImage *image) {
//                                               cell.profilePhotoimageView.image = image;
//                                           }];
    cell.profilePhotoimageView.image = [UIImage imageNamed:@"image-after.jpg"];
    
        [cell.numberOFFriends addTarget:self
                                 action:@selector(showListOfFriendsAction)
                       forControlEvents:UIControlEventTouchUpInside];
        
        [cell.addToFriendButton addTarget:self
                                   action:@selector(addFriendAction:)
                         forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.sendMessageButton addTarget:self
                                   action:@selector(sendMessageAction:)
                         forControlEvents:UIControlEventTouchUpInside];
        
        [cell.uploadPictureImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *uploadImagesTap = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(uploadUserPhoto:)];
        [uploadImagesTap setNumberOfTapsRequired:1];
        [cell.uploadPictureImageView addGestureRecognizer:uploadImagesTap];
        
        [cell.profilePhotoimageView setUserInteractionEnabled:YES];
        cell.profilePhotoimageView.tag = indexPath.row;
        UITapGestureRecognizer *uploadProfilePictureTap = [[UITapGestureRecognizer alloc]
                                                           initWithTarget:self
                                                           action:@selector(uploadProfilePicture:)];
        [uploadProfilePictureTap setNumberOfTapsRequired:1];
        [cell.profilePhotoimageView addGestureRecognizer:uploadProfilePictureTap];
        
        
        [cell.numberOfPhoto setUserInteractionEnabled:YES];
        UITapGestureRecognizer *moveToGalerryTap = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(moveToGalleryViewController:)];
        [moveToGalerryTap setNumberOfTapsRequired:1];
        [cell.numberOfPhoto addGestureRecognizer:moveToGalerryTap];
        
        return cell;
//    }
//    else
//    {
//        EventCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" ];
//     
//        
//        cell.eventImageView.image = [UIImage imageNamed:@"imageRight.png"];
//        cell.userImageView.image = [[EventContent sharedEventContent].eventsArray[indexPath.row -1] profileImage];
//        cell.eventContentLabel.text = [[EventContent sharedEventContent].eventsArray[indexPath.row -1] subtitle];
//        
//        
//        [self adjustImageHeightForCell:cell];
//        [self adjustStringFormat:cell];
//        return cell;
//        
//    }
}

-(void)addFriendAction:(UIButton *)sender
{
    NSLog(@"AddFriends");
    [[RequestManager sharedManager] addFriendWithId:self.userID
                                            success:^(id responseObject) {
                                                NSLog(@"Add friend succes response : %@", responseObject);
                                            } fail:^(NSError *error, NSInteger statusCode) {
                                                
                                            }];
}
-(void)showListOfFriendsAction
{
    NSLog(@"List");
}
-(void)sendMessageAction:(UIButton *)sender
{
        NSLog(@"message");
}


#pragma PhotoGalleryAction

-(void)moveToGalleryViewController:(UITapGestureRecognizer *)sender
{
    GalleryViewController *galleryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
    [self.navigationController pushViewController:galleryViewController animated:YES];
}

#pragma Profile Picture  && Upload
-(void)uploadProfilePicture:(UITapGestureRecognizer *) sender
{
    selectRow = sender.view.tag;
    gestureTapped = 1;
    NSLog(@"sender = %ld", (long)selectRow);
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Upload photo"
                                        message:@"Select method of input"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                
      imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
       [self presentViewController:imagePickerController animated:YES completion:nil];
                                                NSLog(@"Clicked Gallery"); }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Take a Photo"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                
     imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
     [self presentViewController:imagePickerController animated:YES completion:nil];
                                                
                                                NSLog(@"Clicked Camera");}]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Cancel");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)uploadUserPhoto:(UITapGestureRecognizer *) sender
{
    selectRow = sender.view.tag;
    gestureTapped = 2;
    NSLog(@"sender = %ld", (long)selectRow);
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Upload photo"
                                        message:@"Select method of input"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
     NSLog(@"Clicked Gallery"); }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Take a Photo"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                             
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
                                                
    NSLog(@"Clicked Camera");}]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Cancel");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
 
    UserProfileCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0]];
    
    if (gestureTapped == 1) {
        cell.profilePhotoimageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"Respond");

    }
    else if (gestureTapped == 2){
  
        if(cell.pictureImageView.image == nil)
        {
            cell.pictureImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        else if (cell.picture2ImageView.image == nil)
        {
            cell.picture2ImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        else if (cell.pictureImageView.image !=nil && cell.picture2ImageView.image!=nil)
        {
            cell.picture2ImageView.image = cell.pictureImageView.image;
            cell.pictureImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
      [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma Adjustments

-(void)adjustButtonContentFormatForCell:(EventCell *) cell {
    [cell.dislikeButton setImage:[UIImage imageNamed:@"dislike-icon-hightlighted"] forState:UIControlStateNormal];
    [cell.dislikeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cell.likeButton setImage:[UIImage imageNamed:@"like-icon-higtlighted"] forState:UIControlStateNormal];
    [cell.likeButton setTitleColor:[UIColor colorWithRed:(155/255.0) green:186/255.0 blue:205/255.0 alpha:1.0]
                          forState:UIControlStateNormal];
}

-(void)adjustImageHeightForCell:(EventCell *) cell {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [cell.eventImageView removeConstraint: cell.eventImageView.constraints.lastObject];
    if (cell.eventImageView.image != nil) {
        if(cell.eventImageView.image.size.width >= width) {
            correctedHeight = (width - 40)/ cell.eventImageView.image.size.width * cell.eventImageView.image.size.height;
            //            [cell.cellImage setTranslatesAutoresizingMaskIntoConstraints:NO];
            //            [cell.cellImage removeConstraint: cell.cellImage.constraints.lastObject];
            [cell.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:cell.eventImageView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:correctedHeight]];
        }
    }
    
    else {
        [cell.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:cell.eventImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:0]];
    }
}

-(void)adjustStringFormat:(EventCell *) cell {
    
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
    
    cell.nameLabel.attributedText = mutableAttributedString;
}

#pragma mark - GetAgeFromDate

-(NSInteger)getAgeFromDate:(NSString *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* birthdayString = date;
    NSDate* birthday = [dateFormatter dateFromString:birthdayString];
    NSDate* currentDate = [NSDate date];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:currentDate
                                       options:0];
    
    NSInteger age = [ageComponents year];
    
    NSLog(@"birthday - %@", [dateFormatter stringFromDate:currentDate]);
    NSLog(@"current date - %@", [dateFormatter stringFromDate:birthday]);
    NSLog(@"User age is - %ld", (long)age);
    
    return age;
}

@end
