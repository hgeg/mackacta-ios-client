//
//  MKSettingsViewController.h
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface MKSettingsViewController : UIViewController

@property (strong, nonatomic) NSArray *teams;
@property (weak, nonatomic) IBOutlet UIView *teamView;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIButton *devam;
@property (weak, nonatomic) IBOutlet UISwitch *
national;

- (IBAction)showNationalMatches:(id)sender;

@end
