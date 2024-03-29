//
//  MKFirstViewController.h
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MKMatchView.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <iAd/iAd.h>

@interface MKFixtureController : UIViewController
{
    int sliderShown;
    BOOL sLock;
    int gLock;
    int nextweek;
    int offset;
    int previndex;
    dispatch_queue_t queue;
    NSOperationQueue *liveq;
    NSString *myTeam;
    NSArray *data;
    __block UIActivityIndicatorView *aiw;
}

@property (nonatomic, strong) ACAccountStore *accountStore;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet NSMutableArray *matches;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *fbShare;
@property (weak, nonatomic) IBOutlet UIButton *twShare;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;

-(IBAction)twitter:(id)sender;
-(IBAction)facebook:(id)sender;

-(void)updateMatches;

@end
