//
//  MKSecondViewController.h
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface MKStandingsController : UIViewController <UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate>

{
    NSArray *teams;
    BOOL loading;
    dispatch_queue_t queue;
    
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@end
