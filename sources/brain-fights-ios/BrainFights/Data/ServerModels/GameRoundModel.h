//
//  GameRoundModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRoundQuestionModel.h"

@interface GameRoundModel : NSObject
/**
 * Идентификатор раунда
 */
@property NSUInteger id;

/**
 * Вопросы в раунде
 */
@property NSMutableArray* questions;

@end
