//
//  MKSecondViewController.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKStandingsController.h"
#import "gnLoadingView.h"

@interface MKStandingsController ()

@end

@implementation MKStandingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	queue = dispatch_queue_create("com.orkestra.mackacta.standingsqueue",nil);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:@"active" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"entered");
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"flags"] != @"valid") {
        NSLog(@"invalid");
        [gnLoadingView showOnView:self.view];
        dispatch_async(queue, ^{
            NSURL *URL = [NSURL URLWithString:@"http://54.235.244.172/ptable/spor-toto-super-lig/"];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
            [self performSelectorOnMainThread:@selector(generateTeams:) withObject:json waitUntilDone:YES];
        });
        [[NSUserDefaults standardUserDefaults] setValue:@"valid" forKey:@"flags"];
    }
}

- (void)generateTeams:(NSObject *)pobj {
    NSDictionary *params = (NSDictionary *)pobj;
    teams = params[@"data"];
    [self.table reloadData];
    [gnLoadingView hideLoader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSLog(@"count: %d",[teams count]);
        return [teams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
        NSDictionary *team = teams[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"teamdata" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:1]).text = team[@"name"];
        ((UIImageView *)[cell viewWithTag:10]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-logo.png",team[@"name"]]];
        ((UILabel *)[cell viewWithTag:2]).text = team[@"p"];
        ((UILabel *)[cell viewWithTag:3]).text = team[@"w"];
        ((UILabel *)[cell viewWithTag:4]).text = team[@"d"];
        ((UILabel *)[cell viewWithTag:5]).text = team[@"l"];
        ((UILabel *)[cell viewWithTag:6]).text = team[@"av"];
        ((UILabel *)[cell viewWithTag:7]).text = team[@"point"];
        //((UILabel *)[cell viewWithTag:7]).textColor = [UIColor redColor];
        ((UILabel *)[cell viewWithTag:11]).text = [NSString stringWithFormat:@"%d.",indexPath.row+1];
    return cell;
    
}

@end
