//
//  ChoiceSearchActionTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "ChoiceSearchActionTableViewCell.h"

@implementation ChoiceSearchActionTableViewCell

- (void)awakeFromNib {
    self.roundView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.roundView.layer.cornerRadius = 5.0;
    [self initView:self.imageView];
    self.choiceActionTitle.textColor = [Constants SYSTEM_COLOR_WHITE];
    self.imageViewContainer.backgroundColor = [UIColor clearColor];
    
    self.roundView.layer.cornerRadius = 5.0;
    self.roundView.layer.masksToBounds = NO;
    self.roundView.layer.shadowOffset = CGSizeMake(1, 1);
    self.roundView.layer.shadowRadius = 3;
    self.roundView.layer.shadowOpacity = 0.5;
    self.backgroundColor =[Constants SYSTEM_COLOR_WHITE];
    
}

-(void) initView:(UIView*) view {
    /*
    view.layer.shadowColor = [UIColor purpleColor].CGColor;
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.frame cornerRadius:50.0].CGPath;
     */
    //self.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    /*
    [self.imageView.layer setCornerRadius:10.0];
    [self.imageView.layer setMasksToBounds:YES];
    self.imageView.clipsToBounds = YES;
    
    self.imageViewContainer.backgroundColor = [UIColor clearColor];
    self.imageViewContainer.layer.shadowColor = [Constants SYSTEM_COLOR_WHITE].CGColor;
    self.imageViewContainer.layer.shadowOffset = CGSizeMake(0,0);
    self.imageViewContainer.layer.shadowOpacity = 0.5;
    self.imageViewContainer.layer.shadowRadius = 5.0;
    //self.imageViewContainer.layer.masksToBounds = NO;
    self.imageViewContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.imageViewContainer.bounds cornerRadius:0.0].CGPath;
    */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) initCell:(NSString*) choiceActionTitle withImage:(NSString*)iconName {
    [self.choiceActionTitle setText:choiceActionTitle];
    [self.iconImage setImage:[UIImage imageNamed:iconName]];
}

@end
