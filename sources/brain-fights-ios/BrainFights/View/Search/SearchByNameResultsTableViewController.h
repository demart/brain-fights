//
//  SearchByNameResultsTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface SearchByNameResultsTableViewController : BaseTableViewController

// Отфильтрованные пользователи
@property NSMutableArray *filteredUsers;

// Был ли запрос поиска кого-то пользователем
@property BOOL wasSearchQueryRequested;

@end
