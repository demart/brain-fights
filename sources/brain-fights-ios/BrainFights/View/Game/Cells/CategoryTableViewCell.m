//
//  CategoryTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "CategoryTableViewCell.h"

@interface CategoryTableViewCell()

@property GameRoundCategoryModel* categoryModel;

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) initCell:(GameRoundCategoryModel*)categoryModel {
    self.categoryModel = categoryModel;
    
    [self.categoryTitle setText:categoryModel.name];
}

@end
