//
//  MKTeamListController.h
//  Maç Kaçta
//
//  Created by Ali Can Bülbül on 1/30/13.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MKTeamListController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UITableViewCell *selected;


@end
