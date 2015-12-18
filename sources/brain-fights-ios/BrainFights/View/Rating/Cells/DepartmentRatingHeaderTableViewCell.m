//
//  DepartmentRatingHeaderTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentRatingHeaderTableViewCell.h"

@interface DepartmentRatingHeaderTableViewCell()

@property (nonatomic, copy) void (^showSortingOptionsAction)(void);
@property UITapGestureRecognizer *tapRecognizer;

@end


@implementation DepartmentRatingHeaderTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) initCellWithTitle:(NSString*)title andShowSortingOptionsAction:(void (^)(void))showSortingOptionsAction {
    if (title == nil) {
        [self.titleLabel setText:@"Подразделения ▾"];
    } else {
        [self.titleLabel setText:[[NSString alloc] initWithFormat:@"%@ ▾", title]];
    }
    
    // Ставим прошлушку на View
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shortingOptionsViewTapped:)];
    [self.tapRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:self.tapRecognizer];
    
    self.showSortingOptionsAction = showSortingOptionsAction;
}


// Пользователь нажал на кнопку
- (void) shortingOptionsViewTapped:(UITapGestureRecognizer *)recognizer {
    self.showSortingOptionsAction();
}

@end
