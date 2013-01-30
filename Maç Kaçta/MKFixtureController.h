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
#define weeks 22

@interface MKFixtureController : UIViewController <UIScrollViewDelegate>

{
    int sliderShown;
    BOOL sLock;
    int gLock;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet MKMatchView *matchView;
@property (weak, nonatomic) IBOutlet UIView *sliderBar;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet NSMutableArray *matches;
@property (weak, nonatomic) IBOutlet UIImageView *background;

-(IBAction)sliderChanged:(id)sender;
-(IBAction)lockSlider:(id)sender;
-(IBAction)releaseSlider:(id)sender;

@end
