//
//  MKSecondViewController.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKStandingsController.h"

@interface MKStandingsController ()

@end

@implementation MKStandingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    NSURL *URL = [NSURL URLWithString:@"http://54.235.244.172/ptable/spor-toto-super-lig/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
        [self performSelectorOnMainThread:@selector(generateTeams:) withObject:json waitUntilDone:YES];
    });
}

- (void)generateTeams:(NSObject *)pobj {
    NSDictionary *params = (NSDictionary *)pobj;
    teams = params[@"data"];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if(loading)
        return 1;
    else
        return [teams count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell *cell;
    if (loading) {
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"loading" forIndexPath:indexPath];
    }else {
        NSDictionary *team = teams[indexPath.row];
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"teamdata" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:1]).text = team[@"name"];
        ((UIImageView *)[cell viewWithTag:10]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-logo",team[@"name"]]];
        ((UILabel *)[cell viewWithTag:2]).text = team[@"p"];
        ((UILabel *)[cell viewWithTag:3]).text = team[@"w"];
        ((UILabel *)[cell viewWithTag:4]).text = team[@"d"];
        ((UILabel *)[cell viewWithTag:5]).text = team[@"l"];
        ((UILabel *)[cell viewWithTag:6]).text = team[@"av"];
        ((UILabel *)[cell viewWithTag:7]).text = team[@"point"];
        ((UILabel *)[cell viewWithTag:7]).textColor = [UIColor redColor];
    }
    return cell;
    
}

@end
