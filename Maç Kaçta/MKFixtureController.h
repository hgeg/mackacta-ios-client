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

@interface MKFixtureController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>
{
    int sliderShown;
    BOOL sLock;
    int gLock;
    int nextweek;
    int offset;
    int previndex;
    dispatch_queue_t queue;
    NSString *myTeam;
    NSArray *data;
}

@property (nonatomic, strong) ACAccountStore *accountStore;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet MKMatchView *matchView;
@property (weak, nonatomic) IBOutlet UIView *sliderBar;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet NSMutableArray *matches;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *fbShare;
@property (weak, nonatomic) IBOutlet UIButton *twShare;

-(IBAction)sliderChanged:(id)sender;
-(IBAction)lockSlider:(id)sender;
-(IBAction)releaseSlider:(id)sender;

-(IBAction)twitter:(id)sender;
-(IBAction)facebook:(id)sender;

@end
