//
//  MKSettingsViewController.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKSettingsViewController.h"

@interface MKSettingsViewController ()

@end

@implementation MKSettingsViewController
@synthesize teams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.teamView.layer.masksToBounds = YES;
    self.teamView.layer.cornerRadius = 8.0f;
    self.settingsView.layer.masksToBounds = YES;
    self.settingsView.layer.cornerRadius = 8.0f;
	// Do any additional setup after loading the view.
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enable) name:@"selected" object:nil];
    }
    @catch (NSException *exception) {}
    
}

- (void) enable {
    self.devam.enabled = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
