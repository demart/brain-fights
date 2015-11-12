//
//  ChoiceSearchActionTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceSearchActionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *choiceActionTitle;

-(void) initCell:(NSString*) choiceActionTitle withImage:(NSString*)iconName;

@end
