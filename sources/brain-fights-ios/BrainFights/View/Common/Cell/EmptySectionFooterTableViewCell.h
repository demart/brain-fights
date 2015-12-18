//
//  EmptySectionFooterTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptySectionFooterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *emptyText;

- (void) setEmptySectionText:(NSString*) text;


@end
