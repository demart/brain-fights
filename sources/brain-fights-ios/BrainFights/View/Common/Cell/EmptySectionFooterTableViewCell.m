//
//  EmptySectionFooterTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "EmptySectionFooterTableViewCell.h"

@implementation EmptySectionFooterTableViewCell

- (void)awakeFromNib {}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) setEmptySectionText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
                                 NSBaselineOffsetAttributeName: @0,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:attributes];
    self.emptyText.attributedText = attributedText;
}

@end
