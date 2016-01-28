//
//  GameQuestionViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/18/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameQuestionViewController.h"

#import "UrlHelper.h"

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
// Таймер для показа подсказки
@property NSTimer *toolTipTimer;

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


@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarConstraint;

@property UIImage *loadingImage;

@property AMPopTip *popTip;

@end

@implementation GameQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    //self.view.backgroundColor = [Constants SYSTEM_COLOR_LIGHTER_GREY];
    
    self.view.backgroundColor = [Constants SYSTEM_COLOR_LIGHTER2_GREY];
    
    
    self.questionView.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
    self.loadingImage = [UIImage imageNamed:@"loadingImageIcon"];
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:3];

    [self initViewLayouts];
    [self initHeader];
    [self initTapGestureRecognizer];

    //[self.progressView setBackgroundColor:[UIColor orangeColor]];
    [self.progressView setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
    
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

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Показываем что мы ожидаем начала игры
    
    // Показывать стрелочку
    [self.goForwardImageView setHidden:NO];
    self.toolTipTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                         target:self
                                                       selector:@selector(showPressToStartRoundToolTip:)
                                                       userInfo:nil
                                                        repeats:NO];
    
    [self initButtonView:self.questionView];
    self.progressViewInitialWidth = self.progressView.frame.size.width;
}

- (void)showPressToStartRoundToolTip:(NSTimer*) timer {
    [self showTopTipWithText:@"Нажимите на категорию, чтобы начать отвечать на вопросы."];
}

- (void) initView:(UIViewController*) gameStatusViewController withGameModel:(GameModel*)gameModel withGameRoundModel:(GameRoundModel*)gameRoundModel{
    self.gameStatusViewController = gameStatusViewController;
    self.gameModel = gameModel;
    self.gameRoundModel = gameRoundModel;
}

- (void) initCategoryTitleView {
    CGRect backgroundView = CGRectMake(self.categoryTitle.layer.bounds.origin.x, self.categoryTitle.layer.bounds.origin.y, self.categoryTitle.layer.bounds.size.width + 25, self.categoryTitle.layer.bounds.size.height + 3);
    
    [self.categoryTitleBackgroundView setBounds:backgroundView];
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    
    mask.frame = self.categoryTitleBackgroundView.layer.bounds;
    CGFloat width = self.categoryTitleBackgroundView.frame.size.width;
    CGFloat height = self.categoryTitleBackgroundView.frame.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, width, 0);
    CGPathAddLineToPoint(path, nil, self.categoryTitle.layer.bounds.size.width + 20, height);
    CGPathAddLineToPoint(path, nil, 0, height);
    CGPathAddLineToPoint(path, nil, 0, 0);
    CGPathCloseSubpath(path);
    
    mask.path = path;
    
    self.categoryTitleBackgroundView.layer.mask = mask;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = self.categoryTitleBackgroundView.bounds;
    shape.path = path;
    shape.lineWidth = 3.0f;
    shape.strokeColor = self.categoryTitleBackgroundView.backgroundColor.CGColor;
    shape.fillColor = self.categoryTitleBackgroundView.backgroundColor.CGColor;
    
    shape.cornerRadius = 5.0f;
    shape.masksToBounds = NO;
    
    [self.categoryTitleBackgroundView.layer insertSublayer: shape atIndex:0];
    CGPathRelease(path);
    

}

// Инициализируем основные элементы экрана
-(void) initViewLayouts {
    // init
    [self initButtonView:self.aAnswerView];
    [self initButtonView:self.bAnswerView];
    [self initButtonView:self.cAnswerView];
    [self initButtonView:self.dAnswerView];
    [self initButtonView:self.questionView];
    
    [self initButtonView:self.firstQuestionAnswerIndicator];
    [self initButtonView:self.secondQuestionAnswerIndicator];
    [self initButtonView:self.thirdQuestionAnswerIndicator];
    
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

-(void) initButtonView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowRadius = 2;
    view.layer.shadowOpacity = 0.5;
    //view.layer.shadowColor = [[Constants SYSTEM_COLOR_GREEN] CGColor];
}


- (void) initHeader {
    if ([self.gameModel.gameRounds count] == 0) {
        [self.roundNumberTitle setText:@"Раунд 1"];
    } else {
        [self.roundNumberTitle setText:[[NSString alloc] initWithFormat:@"Раунд %li",[self.gameModel.gameRounds count]]];
    }
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
            //targetView.backgroundColor = [UIColor greenColor];
            targetView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
        } else {
            //targetView.backgroundColor = [UIColor redColor];
            targetView.backgroundColor = [Constants SYSTEM_COLOR_RED];
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
        [self dismissViewControllerAnimated:YES completion:^{
            [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
        }];
    }
    
    // Сбрасываем таймер
    if (self.toolTipTimer != nil) {
        [self.toolTipTimer invalidate];
    }
    
    if (self.popTip != nil && [self.popTip isVisible]) {
        [self.popTip hide];
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


- (void) showPressToContinueToolTip:(NSTimer*) timer {
    [self showTopTipWithText:@"Нажмите на вопрос для продолжения"];
}

- (void) showPressToCompleteRoundToolTip:(NSTimer*) timer {
    [self showTopTipWithText:@"Вы ответили на все вопросы, нажимте на вопрос, чтобы продолжить"];
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
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Сохраняем Ваш ответ..."];
    [GameService answerOnQuestion:game.id withRound:gameRound.id withQuestionId:question.id withAnswer:userAnswer.id onSuccess:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:YES];
        
        if ([response.status isEqualToString:SUCCESS]) {
            GamerQuestionAnswerResultModel *result = (GamerQuestionAnswerResultModel*)response.data;
            self.lastAnswerResult = result;
            // Показываем что пользователь ответил на вопрос
            question.answer = userAnswer;
            // Если игра закончилась то сообщить игроку об этом
            [self initHeader];
            [self.goForwardImageView setHidden:NO];
            
            if (questionIndex < 2) {
                self.toolTipTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                     target:self
                                                                   selector:@selector(showPressToContinueToolTip:)
                                                                   userInfo:nil
                                                                    repeats:NO];
            } else {
                self.toolTipTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                     target:self
                                                                   selector:@selector(showPressToCompleteRoundToolTip:)
                                                                   userInfo:nil
                                                                    repeats:NO];
            }
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            if ([response.errorCode isEqualToString:@"002"]) {
                // Игра закончена
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
                }];
            } else {
                NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке отправить ответ на сервер. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
                [self showAlertWithTitle:@"Ошибка" andMessage:message onAction:^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
                    }];
                }];
            }
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке отправить ответ на сервер. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self showAlertWithTitle:@"Ошибка" andMessage:message onAction:^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
            }];
        }];
    }];
    
}

// Подсветить коректный ответ и выделить остальные ответы как не правильные
-(void) hightLightAnswers:(NSInteger)answerIndex withCorrrectAnswer:(NSInteger)correctAnswerIndex andOponentAnswer:(NSInteger)oponentAnswerIndex {
    if (answerIndex == correctAnswerIndex) {
        [UIView transitionWithView:self.answerViews[answerIndex] duration:.5 options:UIViewAnimationOptionCurveEaseInOut animations:
         ^{
             [self.answerViews[answerIndex] setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
             [self.answerViewTexts[answerIndex] setTextColor:[UIColor whiteColor]];
         } completion:^(BOOL finished) {
         }];
        
    } else {
        [UIView transitionWithView:self.answerViews[correctAnswerIndex] duration:.5 options:UIViewAnimationOptionCurveEaseInOut animations:
         ^{
             [self.answerViews[correctAnswerIndex] setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
             [self.answerViewTexts[correctAnswerIndex] setTextColor:[UIColor whiteColor]];
             
         } completion:^(BOOL finished) {
         }];

        [UIView transitionWithView:self.answerViews[answerIndex] duration:.2 options:UIViewAnimationOptionCurveEaseInOut animations:
         ^{
             [self.answerViews[answerIndex] setBackgroundColor:[Constants SYSTEM_COLOR_RED]];
             [self.answerViewTexts[answerIndex] setTextColor:[UIColor whiteColor]];
         } completion:^(BOOL finished) {
         }];
    }
    
    // Если уже есть ответы чувака, то показываем их выделяя как-то

    if (oponentAnswerIndex > -1) {
        UIView *oponentAnswer = self.answerViewTexts[oponentAnswerIndex];
        UILabel *oponentName = [[UILabel alloc] init];
        [oponentName setFont:[UIFont fontWithName:@"Gill Sans" size:8.0]];
        [oponentName setTextColor:[Constants SYSTEM_COLOR_BLACK]];
        [oponentName setText:self.gameModel.oponent.user.name];
        oponentName.textAlignment = NSTextAlignmentCenter;
        [oponentName sizeToFit];
        CGRect newFrame = [oponentAnswer.superview convertRect:oponentAnswer.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        [oponentName setFrame:newFrame];
        [self.view addSubview:oponentName];
        [self.view bringSubviewToFront:oponentName];
        [UIView animateWithDuration:1.5
                              delay:.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             oponentName.transform=CGAffineTransformMakeScale(4,4);
                         }
                         completion:^(BOOL finished){
                             [oponentName removeFromSuperview];
                         }];
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
        [self loadCategoryImageInImageView:self.questionImageView withImageUrl:self.gameRoundModel.category.imageUrl];
        [self.categoryTitle setText:self.gameRoundModel.categoryName];
        [self.categoryTitle sizeToFit];
        [self initCategoryTitleView];
        if (self.gameRoundModel.category != nil && self.gameRoundModel.category.imageUrl != nil) {
            self.questionImageView.image = (UIImage *)[LocalStorageService  loadImageFromLocalCache:self.gameRoundModel.category.imageUrl];
        }

        for (UIView *answerView in self.answerViews) {
            [answerView setHidden:YES];
        }
        [self.progressView setHidden:YES];
        [self.questionImageTitle setHidden:YES];
        [self.questionText setText:nil];
        [self.goForwardImageView setHidden:NO];
    }
    
    // Если нужно ответить на первый вопрос
    if (self.state == STATE_WAITING_ANSWER_1) {
        [UIView transitionWithView:self.questionView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self prepareViewForAnswerQuestion:self.gameRoundModel.questions[0] withQuestionIndex:0];
        } completion:^(BOOL finished) {
            [self hideTopTip];
        }];
    }
    
    // Если нужно ответить на второй вопрос
    if (self.state == STATE_WAITING_ANSWER_2) {
        [UIView transitionWithView:self.questionView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self prepareViewForAnswerQuestion:self.gameRoundModel.questions[1] withQuestionIndex:1];
        } completion:^(BOOL finished) {
            [self hideTopTip];
        }];
    }
    
    // Если нужно ответить на третий вопрос
    if (self.state == STATE_WAITING_ANSWER_3) {
        [UIView transitionWithView:self.questionView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self prepareViewForAnswerQuestion:self.gameRoundModel.questions[2] withQuestionIndex:2];
        } completion:^(BOOL finished) {
            [self hideTopTip];
        }];
    }
}

- (void) prepareViewForAnswerQuestion:(GameRoundQuestionModel*)question withQuestionIndex:(NSInteger)questionIndex {
    [self.goForwardImageView setHidden:YES];
    for (UIView *answerView in self.answerViews) {
        if (answerView.isHidden)
            [answerView setHidden:NO];
        [answerView setBackgroundColor:[UIColor whiteColor]];
        
    }
    if (self.progressView.isHidden)
        [self.progressView setHidden:NO];
    
    if ([question.type isEqualToString:QUESTION_TYPE_TEXT]) {
        [self.questionText setText:question.text];
        
        [self.questionImageTitle setHidden:YES];
        [self.questionImageView setHidden:YES];
        
        // TODO Сделать анимацию и как только она закончиться сразу запустить таймер
        [self initTimers];
    } else {
        [self.questionText setHidden:YES];
        
        [self.questionImageTitle setHidden:NO];
        [self.questionImageTitle setText:question.text];
        
        [self.questionImageView setHidden:NO];

        UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:question.imageUrl];
        
        if (loadedImage != nil) {
            self.questionImageView.image = loadedImage;
            // TODO Сделать анимацию и как только она закончиться сразу запустить таймер
            [self initTimers];
        } else {
            self.questionImageView.image = _loadingImage;
            
            NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
            __weak NSBlockOperation *weakOperation = loadImageOperation;
            
            [loadImageOperation addExecutionBlock:^(void){
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                       [UrlHelper imageUrlForQuestionWithPath:question.imageUrl]
                                                                                       ]]];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                    if (! weakOperation.isCancelled) {
                        self.questionImageView.image = image;
                        
                        [LocalStorageService  saveImageToLocalCache:question.imageUrl withData:image];
                        [self.loadImageOperations removeObjectForKey:@"0"];
                        
                        // TODO Сделать анимацию и как только она закончиться сразу запустить таймер
                        [self initTimers];
                    }
                }];
            }];
            
            [_loadImageOperations setObject: loadImageOperation forKey:@"0"];
            if (loadImageOperation) {
                [_loadImageOperationQueue addOperation:loadImageOperation];
            }
        }
    }
    
    for (int i=0; i < [question.answers count]; i++) {
        GameRoundQuestionAnswerModel *answer = question.answers[i];
        UILabel *label = self.answerViewTexts[i];
        [label setText:answer.text];
        [label setTextColor:[UIColor blackColor]];
    }
    
}


// инициализируем таймер для автоматического ответа если чувак сам пролетел
-(void) initTimers {
    if (self.progressTimer != nil)
        [self.progressTimer invalidate];
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                          target:self
                                                        selector:@selector(changeProgressView:)
                                                        userInfo:nil
                                                         repeats:YES];

    if (self.timeoutTimer != nil)
        [self.timeoutTimer invalidate];
    
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(expiredTimeForWaitingAnswer:)
                                   userInfo:nil
                                    repeats:NO];
}

-(void) expiredTimeForWaitingAnswer:(NSTimer *)timer {
    if (self.state == STATE_WAITING_ANSWER_1) {
        [self showAnswerTimeout:0];
        [self initHeader];
        self.state = STATE_WAITING_ANSWER_1_CONTINUE;
    }
    
    if (self.state == STATE_WAITING_ANSWER_2) {
        [self showAnswerTimeout:1];
        [self initHeader];
        self.state = STATE_WAITING_ANSWER_2_CONTINUE;
    }
    
    if (self.state == STATE_WAITING_ANSWER_3) {
        [self showAnswerTimeout:2];
        [self initHeader];
        self.state = STATE_WAITING_ANSWER_3_CONTINUE;
    }
    
    if (timer != nil)
        [timer invalidate];
}

// Метод ожидает когда закончиться время и показывает все вопросы красными и отправляет на сервер информацию
// что пользователь не успел ответить
-(void) showAnswerTimeout:(NSInteger)questionIndex {
    [self.goForwardImageView setHidden:NO];
    for (int i=0; i < [self.answerViews count]; i++) {
        [self.answerViews[i] setBackgroundColor:[UIColor redColor]];
        [self.answerViewTexts[i] setTextColor:[UIColor whiteColor]];
    }
    
    if (self.progressTimer != nil)
        [self.progressTimer invalidate];
    if (self.timeoutTimer != nil)
        [self.timeoutTimer invalidate];
    
    // TODO Вызываем API чтобы показать что чувак не ответил на вопрос
    
    GameModel *game = self.gameModel;
    GameRoundModel *gameRound = self.gameRoundModel;
    GameRoundQuestionModel *question = self.gameRoundModel.questions[questionIndex];
    
    // Call server API
    // TODO show loader
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Сохраняем Ваш ответ..."];
    [GameService answerOnQuestion:game.id withRound:gameRound.id withQuestionId:question.id withAnswer:QUESTION_WITHOUT_ANSWER_ID onSuccess:^(ResponseWrapperModel *response) {
        
        [DejalBezelActivityView removeViewAnimated:YES];
        
        if ([response.status isEqualToString:SUCCESS]) {
            GamerQuestionAnswerResultModel *result = (GamerQuestionAnswerResultModel*)response.data;
            self.lastAnswerResult = result;
            
            question.answer = [[GameRoundQuestionAnswerModel alloc] init];
            question.answer.id = 0;
            question.answer.text = nil;
            question.answer.isCorrect = NO;
            question.answer.isMissingAnswer = YES;
            // Если игра закончилась то сообщить игроку об этом
            [self initHeader];
            
            // Включаем таймер на тул тип
            if (questionIndex < 2) {
                self.toolTipTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                     target:self
                                                                   selector:@selector(showPressToContinueToolTip:)
                                                                   userInfo:nil
                                                                    repeats:NO];
            } else {
                self.toolTipTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                     target:self
                                                                   selector:@selector(showPressToCompleteRoundToolTip:)
                                                                   userInfo:nil
                                                                    repeats:NO];
            }
            
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // TODO Show Error Alert
            if ([response.errorCode isEqualToString:@"002"]) {
                // Игра закончена
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
                }];
            } else {
                NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке отправить ответ на сервер. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
                [self showAlertWithTitle:@"Ошибка" andMessage:message onAction:^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
                    }];
                }];
            }
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке отправить ответ на сервер. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self showAlertWithTitle:@"Ошибка" andMessage:message onAction:^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
            }];
        }];
    }];
}

// Показывает сколько осталось времени в виде полоски
-(void) changeProgressView:(NSTimer *)timer {
    float stepToDescease = self.progressViewInitialWidth / (30 / 0.5 * 2);
    CGRect bounds = self.progressView.frame;
    if (bounds.size.width - stepToDescease > 0) {
        CGRect newRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - stepToDescease, bounds.size.height);
        [self.progressView setFrame:newRect ];
    } else {
        CGRect newRect = CGRectMake(bounds.origin.x, bounds.origin.y, 0, bounds.size.height);
        [self.progressView setFrame:newRect];
        [timer invalidate];
    }
}


- (void) loadCategoryImageInImageView:(UIImageView*)imageView withImageUrl:(NSString*)imageUrl {
    UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:imageUrl];
    
    if (loadedImage != nil) {
        imageView.image = loadedImage;
    } else {
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = loadImageOperation;
        
        [loadImageOperation addExecutionBlock:^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                   [UrlHelper imageUrlForAvatarWithPath:imageUrl]
                                                                                   ]]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                if (! weakOperation.isCancelled) {
                    if (image != nil) {
                        imageView.image = image;
                        [LocalStorageService  saveImageToLocalCache:imageUrl withData:image];
                    }
                    [self.loadImageOperations removeObjectForKey:imageUrl];
                }
            }];
        }];
        
        [_loadImageOperations setObject: loadImageOperation forKey:imageUrl];
        if (loadImageOperation) {
            [_loadImageOperationQueue addOperation:loadImageOperation];
        }
    }
}


-(void) showTopTipWithText:(NSString*)message {
    if (self.popTip == nil) {
        self.popTip = [AMPopTip popTip];
    }
    
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    self.popTip.shouldDismissOnTap = YES;
//    self.popTip.popoverColor = [Constants SYSTEM_COLOR_ORANGE];
//    self.popTip.popoverColor = [UIColor orangeColor];
    self.popTip.popoverColor = [Constants SYSTEM_COLOR_GREEN];
    [self.popTip showText:message direction:AMPopTipDirectionDown maxWidth:self.questionView.frame.size.width inView:self.view fromFrame:self.questionView.frame duration:15];
    self.popTip.tapHandler = ^{
    };
    self.popTip.dismissHandler = ^{
    };
}

-(void)hideTopTip {
    if (self.popTip != nil)
        [self.popTip hide];
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];
}

- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
