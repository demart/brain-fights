//
//  RatingTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "LMDropdownView.h"
#import "DepartmentTypeTableViewCell.h"
#import "DepartmentTypeFilterTableViewCell.h"

@interface RatingTableViewController : BaseTableViewController<LMDropdownViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *ratingSegmentedControl;

- (IBAction)ratingSegmentedControlValueChanged:(UISegmentedControl *)sender;

// Выпадающий список типов подразделений
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;

- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

@end
