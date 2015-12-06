//
//  UserRatingHeaderTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserRatingHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerGroupTitle;

- (void) initCellWithHeaderTitle:(NSString*)title;

@end
