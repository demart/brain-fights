//
//  GameQuestionViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/18/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GameModel.h"
#import "GameService.h"
#import "GamerQuestionAnswerResultModel.h"
#import "GameStatusTableViewController.h"

#import "BaseViewController.h"

@interface GameQuestionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *firstQuestionAnswerIndicator;
@property (weak, nonatomic) IBOutlet UIView *secondQuestionAnswerIndicator;
@property (weak, nonatomic) IBOutlet UIView *thirdQuestionAnswerIndicator;
@property (weak, nonatomic) IBOutlet UILabel *roundNumberTitle;
@property (weak, nonatomic) IBOutlet UILabel *oponentNameTitle;

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UIView *categoryTitleBackgroundView;

@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;

@property (weak, nonatomic) IBOutlet UILabel *questionImageTitle;

@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionText;

@property (weak, nonatomic) IBOutlet UIView *aAnswerView;
@property (weak, nonatomic) IBOutlet UILabel *aAnswerViewText;

@property (weak, nonatomic) IBOutlet UIView *bAnswerView;
@property (weak, nonatomic) IBOutlet UILabel *bAnswerViewText;

@property (weak, nonatomic) IBOutlet UIView *cAnswerView;
@property (weak, nonatomic) IBOutlet UILabel *cAnswerViewText;

@property (weak, nonatomic) IBOutlet UIView *dAnswerView;
@property (weak, nonatomic) IBOutlet UILabel *dAnswerViewText;
@property (weak, nonatomic) IBOutlet UIView *progressView;

- (IBAction)dismissView:(UIButton *)sender;

- (void) initView:(UIViewController*) gameStatusViewController withGameModel:(GameModel*)gameModel withGameRoundModel:(GameRoundModel*)gameRoundModel;

@end
