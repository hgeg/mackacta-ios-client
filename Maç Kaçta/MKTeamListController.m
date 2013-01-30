//
//  MKTeamListController.m
//  Maç Kaçta
//
//  Created by Ali Can Bülbül on 1/30/13.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKTeamListController.h"

@interface MKTeamListController ()

@end

@implementation MKTeamListController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *sel = [tableView cellForRowAtIndexPath:indexPath];
    sel.selectionStyle = UITableViewCellSelectionStyleNone;
    if(sel != self.selected){
        [[NSUserDefaults standardUserDefaults] setValue:((UILabel *)[sel viewWithTag:1]).text forKey:@"selectedTeam"];
        [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flag"];
    [self.selected viewWithTag:2].alpha = 1;
    [sel viewWithTag:2].alpha = 0;
    [sel viewWithTag:2].hidden = false;
    [UIView animateWithDuration:0.2 animations:^{
        [self.selected viewWithTag:2].alpha = 0;
        [sel viewWithTag:2].alpha = 1;
    } completion:^(BOOL finished) {
        [self.selected viewWithTag:2].hidden = true;
        self.selected = sel;
    }];
    }
}

@end
