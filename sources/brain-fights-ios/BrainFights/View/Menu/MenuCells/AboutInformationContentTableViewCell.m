//
//  AboutInformationContentTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AboutInformationContentTableViewCell.h"

@implementation AboutInformationContentTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    /*
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
                                 NSBaselineOffsetAttributeName: @0,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 //NSKernAttributeName : @(-1.0)
                                 };
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.contentText.text
                                                                         attributes:attributes];
    self.contentText.attributedText = attributedText;
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
