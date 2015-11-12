//
//  GameGroupHeaderTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameGroupHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gameGroupHeaderTitle;

- (void) initCell:(NSString*)title;


@end
