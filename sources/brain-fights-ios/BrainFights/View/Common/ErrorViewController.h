//
//  ErrorViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/24/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *connectionLostImage;
@property (weak, nonatomic) IBOutlet UILabel *connectionLostMessage;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
- (IBAction)tryAgainButtonAction:(UIButton *)sender;


- (void) setTryAgainActionSelector:(SEL) tryAgainAction onController:(UIViewController*) targetController;

@end
