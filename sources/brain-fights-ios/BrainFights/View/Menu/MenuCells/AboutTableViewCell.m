//
//  AboutTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AboutTableViewCell.h"

@interface AboutTableViewCell()

@property UITapGestureRecognizer *aphionLabelTap;

@end

@implementation AboutTableViewCell

- (void)awakeFromNib {
    // Слушаем нажание на название разработчика
    _aphionLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAphionWebSite:)];
    [_aphionLabelTap setNumberOfTapsRequired:1];
    [_aphionLabel setUserInteractionEnabled:YES];
    [_aphionLabel addGestureRecognizer:_aphionLabelTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)openAphionWebSite:(UITapGestureRecognizer*) tapRecognizer {
    NSURL *url = [NSURL URLWithString:[UrlHelper aphionUrl]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
