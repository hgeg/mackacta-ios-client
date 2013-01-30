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
    teams = @[@"Beşiktaş", @"Galatasaray", @"Fenerbahçe", @"Trabzonspor"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [teams objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [teams count];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [[NSUserDefaults standardUserDefaults] setValue:[teams objectAtIndex:row] forKey:@"selectedTeam"];
    [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flag"];
}



@end
