//
//  UserProfileModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserType.h"
#import "UserGamePlayingStatus.h"
#import "DepartmentModel.h"

@interface UserProfileModel : NSObject

// COMMON INFO

@property NSUInteger id;

/**
 * Тип пользователя (UserType)
 */
@property NSString *type;

/*
 UserType:
 * Сам игрок
    ME,

 * Друг
    FRIEND,

 * Просто противник
    OPONENT,
*/

/**
 * Имя пользователя
 */
@property NSString *name;

/**
 * Должность пользователя
 */
@property NSString *position;

/**
 * Логин пользователя
 */
@property NSString *login;

/**
 * Почтовый ящик пользователя
 */
@property NSString *email;

/**
 * Ccылка на аватар
 */
@property NSString *imageUrl;

/**
 * Состояние игрока по отношению к пользователю (Играет не играет с ним)
 */
@property NSString *playStatus;

/**
 * Готов играть
 */
//READY,

/**
 * Играет сейчас со мной
 */
//PLAYING,

/**
 * Отпарвили игроку предложение
 */
//INVITED,

/**
 * Игрок ожидает нашего решения
 */
//WAITING,

/**
 * Подразделение где работает ползователь (скорее всего отдел)
 */
//public String organizationUnit;

/**
 * Полная цепочка организационный структуры от начала до отдела где работает пользователь
 * Астана -> Упралвение око -> Департамент услуг -> Отдел ...
 */
//public String fullOrganizationPath;

/**
 * Иерархическая структура к которой относиться данный пользователь
 */
@property DepartmentModel *department;

// STATISTIC

/**
 * Всего игр
 */
@property NSInteger totalGames;

/**
 * Выиграно игр
 */
@property NSInteger wonGames;

/**
 * Проиграно игр
 */
@property NSInteger loosingGames;

/**
 * Игр в ничью
 */
@property NSInteger drawnGames;

/**
 * Рейтинг пользоваля
 */
@property NSInteger score;

/**
 * Позиция пользователя относиться всех остальных игроков
 */
@property NSInteger gamePosition;

@end
