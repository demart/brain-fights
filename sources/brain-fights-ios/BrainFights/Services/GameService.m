//
//  GameService.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameService.h"
#import "GameHelper.h"
#import "AuthorizationService.h"
#import "UrlHelper.h"

@implementation GameService

// получить список игр пользователя
+ (void) retrieveGames:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    
    NSString* authToken = [AuthorizationService getAuthToken];
    
    if (authToken == nil) {
        failure(nil);
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gamesUrl]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForGames];

    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// получить список игр пользователя
+ (void) retrieveGamesGrouped:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gamesGroupedUrl]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForGamesGroups];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}


// отправить приглашение на игру
+ (void) createGameInvitation:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = nil;
    
    if (userId < 1) {
        // Рандомный игрок
        request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameCreateRandomInvitationUrl]]];
    } else {
        request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameCreateInvitationByUserIdUrl:userId]]];
    }
    
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForCreateInvitation];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// принять приглашение сыграть в игру
+ (void) acceptGameInvitation:(NSInteger)gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    if (gameId < 1)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameAcceptInvitationUrl:gameId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForAcceptInvitation];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}


+ (void) retrieveGameInformation:(NSInteger)gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameInformationUrl:gameId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForGameInformation];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}


// Создает новый раунд для игроков
+ (void) genereateGameRound:(NSUInteger)gameId withSelectedCategory:(NSInteger)categoryId  onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameCreateRoundUrl:gameId withSelectedCategoryId:categoryId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForCreatedGameRound];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}



// Возвращает список вопросов к раунду
+ (void) getRoundQuestions:(NSUInteger)gameId withRound:(NSUInteger)roundId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameRoundQuestionsUrl:gameId withRoundId:roundId ]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForGameRoundQuestions];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Отправляет ответ на вопрос на сервер
+ (void) answerOnQuestion:(NSUInteger)gameId withRound:(NSUInteger)roundId withQuestionId:(NSUInteger)questionId withAnswer:(NSUInteger)answerId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameAnswerOnQuestion:gameId withRoundId:roundId withQuestionId:questionId withAnswerId:answerId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForGameAnswerOnQuestion];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Сдаться в указанной игре
+ (void) surrenderGame:(NSUInteger) gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper gameSurrenderUrl:gameId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [GameHelper buildResponseDescriptorForGameSurrender];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

@end
