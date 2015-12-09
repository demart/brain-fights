//
//  DepartmentModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepartmentTypeModel.h"

@interface DepartmentModel : NSObject

/**
 * Идентификатор записи
 */
@property NSUInteger id;

/**
 * Наименование подразделения
 */
@property NSString *name;

/**
 * Тип подразделения
 */
@property DepartmentTypeModel* type;

/**
 * Кол-во пользователь в подразделении
 */
@property NSInteger userCount;

/**
 * Рейтинг подразделения
 */
@property NSInteger score;

/**
 * Позиция подразделения (прошлая статистика)
 */
@property NSInteger lastPosition;

/**
 * Глобальная позиции подразделения (прошлая статистика)
 */
@property NSInteger lastGlobalPosition;

/**
 * Время последнего пересчета статистики
 */
@property NSString *lastStatisticsUpdate;

/**
 * Есть ли подразделения на уровне ниже
 */
@property Boolean haveChildren;

/**
 * Подразделения
 *      List<DepartmentModel>
 */
@property NSMutableArray *children;

/**
 * Родительское подразделение
 */
@property DepartmentModel *parent;

/**
 * Список игроков в подразделении
 *      List<UserProfileModel>
 */
@property NSMutableArray *users;

/**
 * Принадлежит ли пользователь к этому подразделению
 */
@property Boolean isUserBelongs;

// Время последнего обновления в формате
-(NSDate*) getLastStatisticsUpdateDate;

@end
