//
//  UserSearchResultModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSearchResultModel : NSObject

/**
 * Список найденный пользователей
 */
@property NSMutableArray *users;

/**
 * Кол-во найденных пользователей
 */
@property NSInteger count;

/**
 * Всего найдено пользователей
 */
@property NSUInteger totalCount;

@end
