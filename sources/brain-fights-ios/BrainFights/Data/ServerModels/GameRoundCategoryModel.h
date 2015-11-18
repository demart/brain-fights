//
//  GameRoundCategoryModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRoundCategoryModel : NSObject

/**
 * Идентификатор категории
 */
@property NSUInteger id;

/**
 * Название категории
 */
@property NSString* name;

/**
 * Цвет кагории, не понятно как передавать пока
 */
@property NSString* color;

/**
 * Список вопросовов в категории
 */
@property NSMutableArray* questions;

@end
