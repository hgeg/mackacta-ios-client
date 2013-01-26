//
//  MKFirstViewController.h
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKFirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *homeLogo;
@property (weak, nonatomic) IBOutlet UIImageView *awayLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awayName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *stadium;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *week;

@end
