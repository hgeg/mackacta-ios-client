//
//  MKFirstViewController.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKFixtureController.h"

@interface MKFixtureController()

@end

@implementation MKFixtureController

@synthesize scroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
    sliderShown = false;
    sLock = false;
    self.sliderBar.alpha=0;
    self.sliderBar.layer.masksToBounds = true;
    self.sliderBar.layer.cornerRadius = 4.0f;
    self.sliderBar.frame = CGRectMake(68, self.view.frame.size.height-70, 196, 36);
    self.slider.value = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
    CGSize mySize = self.view.frame.size;
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mySize.width, mySize.height)];
    scroller.delegate = self;
    scroller.pagingEnabled = true;
    scroller.contentSize = CGSizeMake(mySize.width*weeks, mySize.height);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    for (int i = 0; i<weeks; i++) {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://54.235.244.172/match/Galatasaray/%u/",i+1]];
        NSLog(@"url: %@",URL);
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        dispatch_async(queue, ^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
            NSLog(@"adding view...");
            [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json,@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height]],@"i":[NSString stringWithFormat:@"%d",i ],@"scroller":scroller} waitUntilDone:NO];
            NSLog(@"adding view...");
            
        });
    }
    [self.matchView removeFromSuperview];
    [self.view addSubview:scroller];
    [self.view bringSubviewToFront:self.sliderBar];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSlider)];
    [scroller addGestureRecognizer:sliderTap];
}

-(IBAction)sliderChanged:(id)sender {
    [scroller setContentOffset:CGPointMake((int)(self.slider.value*320*(weeks-1)/320)*320, 0) animated:false];
}

-(IBAction)lockSlider:(id)sender {sLock = true;}

-(IBAction)releaseSlider:(id)sender {sLock = false;}

-(void)toggleSlider {
    if(!sliderShown) {
        self.sliderBar.hidden = false;
        [UIView animateWithDuration:0.3 animations:^{
            self.sliderBar.alpha = 1;
        }];
        sliderShown = true;
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.sliderBar.alpha = 0;
        } completion:^(BOOL finished) {
            self.sliderBar.hidden = true;
            sliderShown = false;
        }];
    }
}

- (void)generateView:(NSObject *)pobj {
    NSDictionary *params = (NSDictionary *)pobj;
    MKMatchView *newView = [MKMatchView generateWithObject:params[@"json"] size:CGSizeMake([params[@"mySize"][0] floatValue], [params[@"mySize"][1] floatValue]) andOffset:[params[@"i"] intValue]];
    [params[@"scroller"] addSubview:newView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!sLock) {
        self.slider.value = scrollView.contentOffset.x*1.0/((weeks-1)*320);
    } 
}

@end
