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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.paragraphSpacingBefore = 5;
    paragraphStyle.firstLineHeadIndent = 0;
//    paragraphStyle.lineSpacing = .0;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f],
                                 NSBaselineOffsetAttributeName: @0,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSKernAttributeName : @(-1)
                                 };
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentText.attributedText];
    
    [mutableString addAttributes:attributes range:NSMakeRange(0, mutableString.length)];
    
    //NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.contentText.text
    //                                                                     attributes:attributes];
    self.contentText.attributedText =  mutableString;
    [self.contentText sizeToFit];
    self.contentText.textAlignment = NSTextAlignmentJustified;
    [self.contentText sizeToFit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
