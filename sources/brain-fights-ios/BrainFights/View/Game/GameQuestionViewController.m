//
//  GameQuestionViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/18/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameQuestionViewController.h"


static NSInteger STATE_WAITING_START = 0;
static NSInteger STATE_WAITING_ANSWER_1 = 1;
static NSInteger STATE_WAITING_ANSWER_1_CONTINUE = 2;
static NSInteger STATE_WAITING_ANSWER_2 = 3;
static NSInteger STATE_WAITING_ANSWER_2_CONTINUE = 4;
static NSInteger STATE_WAITING_ANSWER_3 = 5;
static NSInteger STATE_WAITING_ANSWER_3_CONTINUE = 6;

// Идентификатор для ответов когда пользователь не выбрал ответ за указанное время
static NSInteger QUESTION_WITHOUT_ANSWER_ID = -1;

@interface GameQuestionViewController ()

@property UIViewController *gameStatusViewController;
@property GameModel* gameModel;
@property GameRoundModel* gameRoundModel;
@property GamerQuestionAnswerResultModel* lastAnswerResult;

@property NSMutableArray *answerViewTexts;
@property NSMutableArray *answerViews;
@property NSMutableArray *answerViewTapGestures;

@property NSInteger progressViewInitialWidth;

// Таймер для отсчета времени до конца ожидания ответа
@property NSTimer *timeoutTimer;
// Таймер сокращения полоски прогресса
@property NSTimer *progressTimer;

@property NSInteger state;
//  0 - Waiting when user tap to start answering questions
//  1 - When user answering on first questions
//  2 - When user answered on first questions and we are waiting to tap
//  3 - When user answering on second questions
//  4 - When user answered on seconds questions ans we are waiting to tap
//  5 - When user answering on third question
//  6 - When user answered on third questions
//      Round is Finished
//      Game is Finished

@end

@implementation GameQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewLayouts];
    [self initHeader];
    [self initTapGestureRecognizer];
    
    // Показываем что мы ожидаем начала игры
    self.state = STATE_WAITING_START;
    [self initNextStep];
    
    // На вход получаем актуальные вопросы раунда
    // Отображаем категорию и предлагаем начать
    // Проверяем на какиые вопросы уже есть ответы
    // Показываем вопрос на который еще нет ответа
        // Запускаем таймер
        // При нажатии на ответ
            // Показываем правильный
            // Отрпавляем данные на сервер
            // Блокируем всё
    // Пользователь нажимает продолжить, повторяются шаги вопросов
    // Если с сервера приходит информация что все вопросы отвечены
        // При продолжении возвращаем пользователя на статус игры
            // Обновляем данные
    // Если с серверс приходит информация что игра завершена
        // При продолжении возвращаем пользователя на статус игры
            // Показываем окно результата
            // Обновляем данные и показваем что да как
    
}


-(void) viewDidAppear:(BOOL)animated {
    self.progressViewInitialWidth = self.progressView.frame.size.width;
}

- (void) initView:(UIViewController*) gameStatusViewController withGameModel:(GameModel*)gameModel withGameRoundModel:(GameRoundModel*)gameRoundModel{
    self.gameStatusViewController = gameStatusViewController;
    self.gameModel = gameModel;
    self.gameRoundModel = gameRoundModel;
}


// Инициализируем основные элементы экрана
-(void) initViewLayouts {
    // init
    self.aAnswerView.layer.cornerRadius = 5.0;
    self.bAnswerView.layer.cornerRadius = 5.0;
    self.cAnswerView.layer.cornerRadius = 5.0;
    self.dAnswerView.layer.cornerRadius = 5.0;
    self.questionView.layer.cornerRadius = 5.0;
    self.firstQuestionAnswerIndicator.layer.cornerRadius = 5.0;
    self.secondQuestionAnswerIndicator.layer.cornerRadius = 5.0;
    self.thirdQuestionAnswerIndicator.layer.cornerRadius = 5.0;
    self.progressView.layer.cornerRadius = 5.0;
    
    self.answerViews = [[NSMutableArray alloc] init];
    [self.answerViews insertObject:self.aAnswerView atIndex:0];
    [self.answerViews insertObject:self.bAnswerView atIndex:1];
    [self.answerViews insertObject:self.cAnswerView atIndex:2];
    [self.answerViews insertObject:self.dAnswerView atIndex:3];
    
    self.answerViewTexts = [[NSMutableArray alloc] init];
    [self.answerViewTexts insertObject:self.aAnswerViewText atIndex:0];
    [self.answerViewTexts insertObject:self.bAnswerViewText atIndex:1];
    [self.answerViewTexts insertObject:self.cAnswerViewText atIndex:2];
    [self.answerViewTexts insertObject:self.dAnswerViewText atIndex:3];
    
}

- (void) initHeader {
    [self.roundNumberTitle setText: [[NSString alloc] initWithFormat:@"Раунд %li",[self.gameModel.gameRounds count]]];
    [self.oponentNameTitle setText:self.gameModel.oponent.user.name];
    
    GameRoundQuestionModel *firstQuestion = self.gameRoundModel.questions[0];
    [self fillColorOnHeaderQuestionsView:firstQuestion onView:self.firstQuestionAnswerIndicator];
    GameRoundQuestionModel *secondQuestion = self.gameRoundModel.questions[1];
    [self fillColorOnHeaderQuestionsView:secondQuestion onView:self.secondQuestionAnswerIndicator];
    GameRoundQuestionModel *thirdQuestion = self.gameRoundModel.questions[2];
    [self fillColorOnHeaderQuestionsView:thirdQuestion onView:self.thirdQuestionAnswerIndicator];
    
}

-(void) fillColorOnHeaderQuestionsView:(GameRoundQuestionModel*)gameRoundQuestionModel onView:(UIView*)targetView {
    if (gameRoundQuestionModel.answer != nil) {
        if (gameRoundQuestionModel.answer.isCorrect) {
            targetView.backgroundColor = [UIColor greenColor];
        } else {
            targetView.backgroundColor = [UIColor redColor];
        }
    } else {
        targetView.backgroundColor = [UIColor whiteColor];
    }
}


// Инициализируем нажатия на View
-(void) initTapGestureRecognizer {
    // Tap on Question
    UITapGestureRecognizer *tapRecognizerForQuestionView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedQuestionView:)];
    [tapRecognizerForQuestionView setNumberOfTapsRequired:1];
    [self.questionView addGestureRecognizer:tapRecognizerForQuestionView];
    
    self.answerViewTapGestures = [[NSMutableArray alloc] init];
    // Tap on Answer A
    UITapGestureRecognizer *tapRecognizerForAnswerA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAnswerView:)];
    [tapRecognizerForAnswerA setNumberOfTapsRequired:1];
    [self.answerViewTapGestures insertObject:tapRecognizerForAnswerA atIndex:0];
    [self.answerViews[0] addGestureRecognizer:tapRecognizerForAnswerA];
    
    // Tap on Answer B
    UITapGestureRecognizer *tapRecognizerForAnswerB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAnswerView:)];
    [tapRecognizerForAnswerB setNumberOfTapsRequired:1];
    [self.answerViewTapGestures insertObject:tapRecognizerForAnswerB atIndex:1];
    [self.answerViews[1] addGestureRecognizer:tapRecognizerForAnswerB];
    
    // Tap on Answer C
    UITapGestureRecognizer *tapRecognizerForAnswerC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAnswerView:)];
    [tapRecognizerForAnswerC setNumberOfTapsRequired:1];
    [self.answerViewTapGestures insertObject:tapRecognizerForAnswerC atIndex:2];
    [self.answerViews[2] addGestureRecognizer:tapRecognizerForAnswerC];
    
    // Tap on Answer D
    UITapGestureRecognizer *tapRecognizerForAnswerD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAnswerView:)];
    [tapRecognizerForAnswerD setNumberOfTapsRequired:1];
    [self.answerViewTapGestures insertObject:tapRecognizerForAnswerD atIndex:3];
    [self.answerViews[3] addGestureRecognizer:tapRecognizerForAnswerD];
    
}


// Событие если чувак нажал на вопрос
// Нужно при
//      1. Начале игры, при нажатии на категории
//      2. Переход к следующему вопросу
//      3. Переход после окончания раунда или игры
//
-(void)tappedQuestionView:(UITapGestureRecognizer *)recognizer {
    if (self.state == STATE_WAITING_START) {
        // Начинаем игру
        // Подгружаем вопрос на который нужно отвечать
        self.state = [self getStateForNextQuestion];
        [self initNextStep];
    }
    
    if (self.state == STATE_WAITING_ANSWER_1_CONTINUE) {
        // Подгружаем второй вопрос
        self.state = [self getStateForNextQuestion];
        [self initNextStep];
    }

    if (self.state == STATE_WAITING_ANSWER_2_CONTINUE) {
        // Подгружаем третий вопрос
        self.state = [self getStateForNextQuestion];
        [self initNextStep];
    }

    if (self.state == STATE_WAITING_ANSWER_3_CONTINUE) {
        // Вопросы законичились
        // Конец раунда или игры, и переход на старницу статуса
        // Передаем информацию о последнем ответе в статус игры
        // Смотрим там как на это реагировать
        [(GameStatusTableViewController*)self.gameStatusViewController lastQuestionAnswerResult:self.lastAnswerResult];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
        }];
    }
    
    // Если другое событие то можно ничего не делать
}

// Событие если чувак нажал на ответ на вопрос
-(void)tappedAnswerView:(UITapGestureRecognizer *)recognizer {
    NSInteger answerIndex = -1;
    for (int i=0; i < [self.answerViews count]; i++) {
        if (recognizer.view == self.answerViews[i]) {
            answerIndex = i;
            break;
        }
    }
    
    if (self.state == STATE_WAITING_ANSWER_1) {
        [self processSelectedAnswer:0 withAnswerIndex:answerIndex];
        self.state = STATE_WAITING_ANSWER_1_CONTINUE;
    }

    if (self.state == STATE_WAITING_ANSWER_2) {
        [self processSelectedAnswer:1 withAnswerIndex:answerIndex];
        self.state = STATE_WAITING_ANSWER_2_CONTINUE;
    }
    
    if (self.state == STATE_WAITING_ANSWER_3) {
        [self processSelectedAnswer:2 withAnswerIndex:answerIndex];
        self.state = STATE_WAITING_ANSWER_3_CONTINUE;
    }
    
    // Любые другие нажатия, например в момент ожидания перехода к следующему вопросу будут игнорироваться
}


-(void) processSelectedAnswer:(NSInteger)questionIndex withAnswerIndex:(NSInteger)answerIndex {
    GameModel *game = self.gameModel;
    GameRoundModel *gameRound = self.gameRoundModel;
    GameRoundQuestionModel *question = self.gameRoundModel.questions[questionIndex];
    GameRoundQuestionAnswerModel *userAnswer = question.answers[answerIndex];
    NSInteger correctAnswerIndex = -1;
    NSInteger oponentAnswerIndex = -1;
    for (int i=0; i < [question.answers count]; i++) {
        GameRoundQuestionAnswerModel *questionAnswer = question.answers[i];
        if (questionAnswer.isCorrect) {
            correctAnswerIndex = i;
        }
        if (question.oponentAnswer != nil) {
            if (questionAnswer.id == question.oponentAnswer.id)
                oponentAnswerIndex = i;
        }
    }
    
    // отключаем таймеры
    if (self.timeoutTimer != nil)
        [self.timeoutTimer invalidate];
    if (self.progressTimer != nil)
        [self.progressTimer invalidate];
    
    // Подстветить кто как ответил на вопрос
    [self hightLightAnswers:answerIndex withCorrrectAnswer:correctAnswerIndex andOponentAnswer:oponentAnswerIndex];
    
    // Call server API
    [GameService answerOnQuestion:game.id withRound:gameRound.id withQuestionId:question.id withAnswer:userAnswer.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            GamerQuestionAnswerResultModel *result = (GamerQuestionAnswerResultModel*)response.data;
            self.lastAnswerResult = result;

            // Показываем что пользователь ответил на вопрос
            question.answer = userAnswer;
            // Если игра закончилась то сообщить игроку об этом
            [self initHeader];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Show Authorization View
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // TODO Show Error Alert
        }
    } onFailure:^(NSError *error) {
        // TODO Show ERROR
    }];
}

// Подсветить коректный ответ и выделить остальные ответы как не правильные
-(void) hightLightAnswers:(NSInteger)answerIndex withCorrrectAnswer:(NSInteger)correctAnswerIndex andOponentAnswer:(NSInteger)oponentAnswerIndex {
    if (answerIndex == correctAnswerIndex) {
        // TODO add animation
        [self.answerViews[answerIndex] setBackgroundColor:[UIColor greenColor]];
        [self.answerViewTexts[answerIndex] setTextColor:[UIColor whiteColor]];
    } else {
        [self.answerViews[correctAnswerIndex] setBackgroundColor:[UIColor greenColor]];
        [self.answerViewTexts[correctAnswerIndex] setTextColor:[UIColor whiteColor]];
        [self.answerViews[answerIndex] setBackgroundColor:[UIColor redColor]];
        [self.answerViewTexts[answerIndex] setTextColor:[UIColor whiteColor]];
    }
    
    // Если уже есть ответы чувака, то показываем их выделяя как-то
    if (oponentAnswerIndex > -1) {
        // TODO анимация для вьюхи
        [self.answerViewTexts[oponentAnswerIndex] setTextColor:[UIColor purpleColor]];
    }
}


// Возвращает шаг вопроса с которого нужно начать, это нужно для того чтобы со старта можно было отвечать на 2 или 3 вопрос
- (NSInteger) getStateForNextQuestion {
    GameRoundQuestionModel *question = nil;
    question = self.gameRoundModel.questions[0];
    if (question.answer == nil)
        return STATE_WAITING_ANSWER_1;
    question = self.gameRoundModel.questions[1];
    if (question.answer == nil)
        return STATE_WAITING_ANSWER_2;
    question = self.gameRoundModel.questions[2];
    if (question.answer == nil)
        return STATE_WAITING_ANSWER_3;
    
    // Если уже на всё ответили
    return STATE_WAITING_ANSWER_3_CONTINUE;
}

// Инициализирует вьюху под указанное состояние
-(void) initNextStep {
    // Показываем категорию вопросов
    if (self.state == STATE_WAITING_START) {
        // TODO Показываем картинку
        // TODO Скрыть прогресс бар
        [self.questionText setText:self.gameRoundModel.categoryName];
        for (UIView *answerView in self.answerViews) {
            [answerView setHidden:YES];
        }
        [self.progressView setHidden:YES];
    }
    
    // Если нужно ответить на первый вопрос
    if (self.state == STATE_WAITING_ANSWER_1) {
        [self prepareViewForAnswerQuestion:self.gameRoundModel.questions[0] withQuestionIndex:0];
    }
    
    // Если нужно ответить на второй вопрос
    if (self.state == STATE_WAITING_ANSWER_2) {
        [self prepareViewForAnswerQuestion:self.gameRoundModel.questions[1] withQuestionIndex:1];
    }
    
    // Если нужно ответить на третий вопрос
    if (self.state == STATE_WAITING_ANSWER_3) {
        [self prepareViewForAnswerQuestion:self.gameRoundModel.questions[2] withQuestionIndex:2];
    }
}

- (void) prepareViewForAnswerQuestion:(GameRoundQuestionModel*)question withQuestionIndex:(NSInteger)questionIndex {
    for (UIView *answerView in self.answerViews) {
        if (answerView.isHidden)
            [answerView setHidden:NO];
        [answerView setBackgroundColor:[UIColor whiteColor]];
    }
    if (self.progressView.isHidden)
        [self.progressView setHidden:NO];
    
    [self.questionText setText:question.text];
    
    for (int i=0; i < [question.answers count]; i++) {
        GameRoundQuestionAnswerModel *answer = question.answers[i];
        UILabel *label = self.answerViewTexts[i];
        [label setText:answer.text];
        [label setTextColor:[UIColor blackColor]];
    }
    
    // TODO Сделать анимацию и как только она закончиться сразу запустить таймер
    [self initTimers];
}


// инициализируем таймер для автоматического ответа если чувак сам пролетел
-(void) initTimers {
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(expiredTimeForWaitingAnswer:)
                                   userInfo:nil
                                    repeats:NO];
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:.2
                                     target:self
                                    selector:@selector(changeProgressView:)
                                    userInfo:nil
                                    repeats:YES];
}

-(void) expiredTimeForWaitingAnswer:(NSTimer *)timer {
    if (self.state == STATE_WAITING_ANSWER_1) {
        // Show error to the user
        // Send data to server without answer
        [self showAnswerTimeout:0];
        [self initHeader];
        self.state = STATE_WAITING_ANSWER_1_CONTINUE;
    }
    
    if (self.state == STATE_WAITING_ANSWER_2) {
        // Show error to the user
        // Send data to server without answer
        [self showAnswerTimeout:1];
        [self initHeader];
        self.state = STATE_WAITING_ANSWER_2_CONTINUE;
    }
    
    if (self.state == STATE_WAITING_ANSWER_3) {
        // Show error to the user
        // Send data to server without answer
        [self showAnswerTimeout:2];
        [self initHeader];
        self.state = STATE_WAITING_ANSWER_3_CONTINUE;
    }
    
    [timer invalidate];
}

// Метод ожидает когда закончиться время и показывает все вопросы красными и отправляет на сервер информацию
// что пользователь не успел ответить
-(void) showAnswerTimeout:(NSInteger)questionIndex {
    for (int i=0; i < [self.answerViews count]; i++) {
        [self.answerViews[i] setBackgroundColor:[UIColor redColor]];
        [self.answerViewTexts[i] setTextColor:[UIColor whiteColor]];
    }
    
    if (self.progressTimer != nil)
        [self.progressTimer invalidate];
    
    // TODO Вызываем API чтобы показать что чувак не ответил на вопрос
    
    GameModel *game = self.gameModel;
    GameRoundModel *gameRound = self.gameRoundModel;
    GameRoundQuestionModel *question = self.gameRoundModel.questions[questionIndex];
    
    // Call server API
    [GameService answerOnQuestion:game.id withRound:gameRound.id withQuestionId:question.id withAnswer:QUESTION_WITHOUT_ANSWER_ID onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            GamerQuestionAnswerResultModel *result = (GamerQuestionAnswerResultModel*)response.data;
            self.lastAnswerResult = result;
            
            question.answer = [[GameRoundQuestionAnswerModel alloc] init];
            question.answer.id = 0;
            question.answer.text = nil;
            question.answer.isCorrect = NO;
            question.answer.isMissingAnswer = YES;
            // Если игра закончилась то сообщить игроку об этом
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Show Authorization View
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // TODO Show Error Alert
        }
    } onFailure:^(NSError *error) {
        // TODO Show ERROR
    }];
    
}

// Показывает сколько осталось времени в виде полоски
-(void) changeProgressView:(NSTimer *)timer {
    long stepToDescease = self.progressViewInitialWidth / 110;
    CGRect bounds = self.progressView.frame;
    if (bounds.size.width - stepToDescease > 0) {
        CGRect newRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - stepToDescease, bounds.size.height);
        [self.progressView setFrame:newRect];
    } else {
        CGRect newRect = CGRectMake(bounds.origin.x, bounds.origin.y, 0, bounds.size.height);
        [self.progressView setFrame:newRect];
        [timer invalidate];
    }
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
