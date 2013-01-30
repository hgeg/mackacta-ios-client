//
//  MKFirstViewController.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKFixtureController.h"
#import "gnLoadingView.h"

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
    gLock = 2;
    
    self.matches = [[NSMutableArray alloc] initWithCapacity:34];
    for (int p=0; p<34; p++) {
        self.matches[p] = @"";
    }
	// Do any additional setup after loading the view, typically from a nib.
    CGSize mySize = self.view.frame.size;
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mySize.width, mySize.height)];
    scroller.delegate = self;
    scroller.pagingEnabled = true;
    scroller.contentSize = CGSizeMake(mySize.width*34, mySize.height);
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    self.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"Beşiktaş-bg.jpg"]];
    NSString* escapedUrlString =
    [@"http://54.235.244.172/globals/Beşiktaş/" stringByAddingPercentEscapesUsingEncoding:
     NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:escapedUrlString];
    NSLog(@"url: %@",URL);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
    int nextweek = [json[@"week"] integerValue];
    NSLog(@"next: %d",nextweek);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    for (int i = 0; i<=34; i++) {
        if(nextweek-i<1 && nextweek+i+1>34) break;
        else if(nextweek-i>0){
            NSString* escapedUrlString =
            [[NSString stringWithFormat:@"http://54.235.244.172/match/Beşiktaş/%u/",nextweek-i] stringByAddingPercentEscapesUsingEncoding:
             NSUTF8StringEncoding];
            URL = [NSURL URLWithString:escapedUrlString];
            request = [NSURLRequest requestWithURL:URL];
            
            dispatch_async(queue, ^{
                NSURLResponse *response = nil;
                NSError *error = nil;
                
                NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                             returningResponse:&response
                                                                         error:&error];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
                [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json[@"data"],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height]],@"i":[NSString stringWithFormat:@"%d",nextweek-i-1 ],@"scroller":scroller} waitUntilDone:NO];
            });
        }
        if(nextweek+i+1<35){
            NSString* escapedUrlString =
            [[NSString stringWithFormat:@"http://54.235.244.172/match/Beşiktaş/%u/",nextweek+i+1] stringByAddingPercentEscapesUsingEncoding:
             NSUTF8StringEncoding];
            URL = [NSURL URLWithString:escapedUrlString];
            request = [NSURLRequest requestWithURL:URL];
            
            dispatch_async(queue, ^{
                NSURLResponse *response = nil;
                NSError *error = nil;
                
                NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                             returningResponse:&response
                                                                         error:&error];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
                [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json[@"data"],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height]],@"i":[NSString stringWithFormat:@"%d",nextweek+i],@"scroller":scroller} waitUntilDone:NO];
            });
        }
    }
    [self.matchView removeFromSuperview];
    [self.view addSubview:self.scroller];
    self.scroller.contentOffset = CGPointMake((nextweek-1)*320, 0);
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSlider)];
    [scroller addGestureRecognizer:sliderTap];
    
    [self.view bringSubviewToFront:self.sliderBar];
}

-(void) viewDidAppear:(BOOL)animated {
    [gnLoadingView showOnView:self.view];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"invalid"] && [[NSUserDefaults standardUserDefaults] valueForKey:@"invalid"] == @"invalid") {
        [self.scroller removeFromSuperview];
        
        sliderShown = false;
        sLock = false;
        self.sliderBar.alpha=0;
        self.sliderBar.layer.masksToBounds = true;
        self.sliderBar.layer.cornerRadius = 4.0f;
        self.sliderBar.frame = CGRectMake(68, self.view.frame.size.height-70, 196, 36);
        self.slider.value = 0;
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSString *selectedTeam = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"];
        NSString* escapedUrlString =
        [[NSString stringWithFormat:@"http://54.235.244.172/globals/%@/",selectedTeam] stringByAddingPercentEscapesUsingEncoding:
         NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:escapedUrlString];
        NSLog(@"url: %@",URL);
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
        int nextweek = [json[@"week"] integerValue];
        NSLog(@"next: %d",nextweek);
        
        // Do any additional setup after loading the view, typically from a nib.
        CGSize mySize = self.view.frame.size;
        self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mySize.width, mySize.height)];
        self.scroller.delegate = self;
        self.scroller.pagingEnabled = true;
        self.scroller.contentSize = CGSizeMake(mySize.width*34, mySize.height);
        [UIView animateWithDuration:0.3 animations:^{
            self.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-bg.jpg",[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"]]];
        }];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        for (int i = 0; i<=34; i++) {
            if(nextweek-i<1 && nextweek+i+1>34){
                break;
            }
            else if(nextweek-i>0){
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"http://54.235.244.172/match/%@/%u/", selectedTeam,nextweek-i] stringByAddingPercentEscapesUsingEncoding:
                 NSUTF8StringEncoding];
                URL = [NSURL URLWithString:escapedUrlString];
                request = [NSURLRequest requestWithURL:URL];
                
                dispatch_async(queue, ^{
                    NSURLResponse *response = nil;
                    NSError *error = nil;
                    
                    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                                 returningResponse:&response
                                                                             error:&error];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
                    [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json[@"data"],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height+49]],@"i":[NSString stringWithFormat:@"%d",nextweek-i-1 ],@"scroller":scroller} waitUntilDone:NO];
                    NSLog(@"json:%@",json);
                });
            }
            if(nextweek+i+1<35){
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"http://54.235.244.172/match/%@/%u/",selectedTeam,nextweek+i+1] stringByAddingPercentEscapesUsingEncoding:
                 NSUTF8StringEncoding];
                URL = [NSURL URLWithString:escapedUrlString];
                request = [NSURLRequest requestWithURL:URL];
                
                dispatch_async(queue, ^{
                    NSURLResponse *response = nil;
                    NSError *error = nil;
                    
                    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                                 returningResponse:&response
                                                                             error:&error];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
                    [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json[@"data"],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height+49]],@"i":[NSString stringWithFormat:@"%d",nextweek+i],@"scroller":scroller} waitUntilDone:NO];
                    NSLog(@"json:%@",json);
                });
            }
        }
        [self.matchView removeFromSuperview];
        [self.view addSubview:self.scroller];
        self.scroller.contentOffset = CGPointMake((nextweek-1)*320, 0);
        [self.view bringSubviewToFront:self.sliderBar];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSlider)];
        [self.scroller addGestureRecognizer:sliderTap];
        self.scroller.showsHorizontalScrollIndicator = false;
        [[NSUserDefaults standardUserDefaults] setValue:@"valid" forKey:@"invalid"];
    }
}

-(IBAction)sliderChanged:(id)sender {
    [scroller setContentOffset:CGPointMake((int)(self.slider.value*320*(33)/320)*320, 0) animated:false];
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
    NSLog(@"at index:%@",params[@"i"]);
    [self.matches insertObject:newView atIndex:[params[@"i"] intValue]];
    newView.alpha=0;
    [params[@"scroller"] addSubview:newView];
    [gnLoadingView hideLoader];
    //if(gLock>0){
        [UIView animateWithDuration:0.3 animations:^{
        newView.alpha = 1;}];
        gLock--;
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!sLock) {
        self.slider.value = scrollView.contentOffset.x*1.0/((34-1)*320);
    }
    /*if(gLock==0)
        [UIView animateWithDuration:0.3 animations:^{
            NSLog(@"at index:%d",(int)(scrollView.contentOffset.x/320));
            ((UIView *)self.matches[(int)(scrollView.contentOffset.x/320)]).alpha = 1;
        }];*/
}

@end
