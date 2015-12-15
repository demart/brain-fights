//
//  DepartmentRatingHeaderTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentRatingHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sortingOptionsImageView;

- (void) initCellWithTitle:(NSString*)title andShowSortingOptionsAction:(void (^)(void))showSortingOptionsAction;

@end
