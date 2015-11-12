//
//  DepartmentSearchResultModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmentSearchResultModel : NSObject

/*
 * Подразделения
 */
@property NSMutableArray *departments;

/*
 * Кол-во найденных подразделений
 */
@property NSInteger count;

@end
