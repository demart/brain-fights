//
//  DepartmentHeaderTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/3/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentTitle;

-(void) initCellWithTitle:(NSString*)title;

@end
