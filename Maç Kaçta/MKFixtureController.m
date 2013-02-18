//
//  MKFirstViewController.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKFixtureController.h"
#import "gnLoadingView.h"
#import "MKAppDelegate.h"

@interface MKFixtureController()

@end

@implementation MKFixtureController

@synthesize scroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
    queue = dispatch_queue_create("com.orkestra.mackacta.fixturequeue", nil);
    sliderShown = true;
    sLock = true;
    self.sliderBar.alpha=0;
    self.sliderBar.layer.masksToBounds = true;
    self.sliderBar.layer.cornerRadius = 4.0f;
    self.sliderBar.frame = CGRectMake(68, self.view.frame.size.height-70, 196, 36);
    self.slider.value = 0;
    gLock = 2;
    offset = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:@"active" object:nil];
}

-(void) viewDidAppear:(BOOL)animated {
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] != @"valid") {
        offset = 0;
        self.matches = [[NSMutableArray alloc] initWithCapacity:34];
        for (int p=0; p<34; p++) {
            self.matches[p] = @"false";
        }
        [gnLoadingView showOnView:self.view];
        [self.scroller removeFromSuperview];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        BOOL n = [[NSUserDefaults standardUserDefaults] boolForKey:@"national"];
        
        sliderShown = false;
        sLock = false;
        self.sliderBar.alpha=0;
        self.sliderBar.layer.masksToBounds = true;
        self.sliderBar.layer.cornerRadius = 4.0f;
        self.sliderBar.frame = CGRectMake(68, self.view.frame.size.height-70, 196, 36);
        self.slider.value = 0;
        
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
        nextweek = [json[@"week"] integerValue];
        previndex = nextweek;
        
        // Do any additional setup after loading the view, typically from a nib.
        CGSize mySize = self.view.frame.size;
        self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mySize.width, mySize.height)];
        self.scroller.delegate = self;
        self.scroller.pagingEnabled = true;
        self.scroller.contentSize = CGSizeMake(mySize.width*34, mySize.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.background.alpha = 0.0;
        [UIView commitAnimations];
        
        self.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-bg.jpg",[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"]]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.background.alpha = 1.0;
        [UIView commitAnimations];
                if(n)
                    escapedUrlString = [[NSString stringWithFormat:@"http://54.235.244.172/match/%@/%u/nationals:yes/", selectedTeam,nextweek] stringByAddingPercentEscapesUsingEncoding:
                 NSUTF8StringEncoding];
                else
                    escapedUrlString = [[NSString stringWithFormat:@"http://54.235.244.172/match/%@/%u/", selectedTeam,nextweek] stringByAddingPercentEscapesUsingEncoding:
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
                    offset = [json[@"offset"] integerValue];
                    if ([json[@"data"] count]==1) {
                        NSLog(@"1 maç var");
                        [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json[@"data"][0],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height+49]],@"i":[NSString stringWithFormat:@"%d",nextweek-1],@"scroller":scroller} waitUntilDone:NO];
                    }else{
                        NSLog(@"sıçtı");
                        UIScrollView *inner = [[UIScrollView alloc] initWithFrame:CGRectMake((nextweek-1)*320, 0, scroller.frame.size.width, scroller.frame.size.height)];
                        inner.pagingEnabled = true;
                        inner.contentSize = CGSizeMake(mySize.width*[json[@"data"] count], mySize.height);
                        inner.showsHorizontalScrollIndicator = false;
                        inner.contentOffset = CGPointMake(offset*mySize.width,0);
                        NSArray *data;
                        for(int i = 0;i<[json[@"data"] count];i++){
                            data = ((NSArray *)json[@"data"])[i];
                            [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":data,@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height+49]],@"i":[NSString stringWithFormat:@"%d",i],@"scroller":inner} waitUntilDone:NO];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [scroller addSubview:inner];
                        });
                    }
                });
        [self.matchView removeFromSuperview];
        [self.view addSubview:self.scroller];
        self.scroller.contentOffset = CGPointMake((nextweek-1)*320, 0);
        int index = (int)(scroller.contentOffset.x/320);
        self.matches[index] = @"true";
        [self.view bringSubviewToFront:self.sliderBar];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSlider)];
        [self.scroller addGestureRecognizer:sliderTap];
        self.scroller.showsHorizontalScrollIndicator = false;
        [[NSUserDefaults standardUserDefaults] setValue:@"valid" forKey:@"flag"];
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
    MKMatchView *newView = [MKMatchView generateWithObject:params[@"json"] week:nextweek size:CGSizeMake([params[@"mySize"][0] floatValue], [params[@"mySize"][1] floatValue]) andOffset:[params[@"i"] intValue]];
    NSLog(@"at index:%@",params[@"i"]);
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
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (int)(scrollView.contentOffset.x/320);
    NSLog(@"%d - %d",previndex,index);
    int diff = previndex-index;
    if (self.matches[index] == @"false") {
        [gnLoadingView showOnView:self.view];
        if (self.matches[index] == @"true") return;
        self.matches[index] = @"true";
        NSString *selectedTeam = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"];
        CGSize mySize = self.view.frame.size;
        BOOL n = [[NSUserDefaults standardUserDefaults] boolForKey:@"national"];
        NSString *escapedUrlString;
        if(n){
            NSLog(@"nationals");
            escapedUrlString = [[NSString stringWithFormat:@"http://54.235.244.172/match/%@/%u/nationals:yes/", selectedTeam,index+1] stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        }else
            escapedUrlString = [[NSString stringWithFormat:@"http://54.235.244.172/match/%@/%u/", selectedTeam,index+1] stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:escapedUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        dispatch_async(queue, ^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                returningResponse:&response
                                                                     error:&error];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
            if (diff>0) {
                offset = [json[@"data"] count]-1;
            }else offset = 0;
            if ([json[@"data"] count]==1) {
                [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":json[@"data"][0],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height+49]],@"i":[NSString stringWithFormat:@"%d",index],@"scroller":scroller} waitUntilDone:NO];
            }else{
                UIScrollView *inner = [[UIScrollView alloc] initWithFrame:CGRectMake(index*320, 0, scroller.frame.size.width, scroller.frame.size.height)];
                inner.pagingEnabled = true;
                inner.contentSize = CGSizeMake(mySize.width*[json[@"data"] count], mySize.height);
                inner.showsHorizontalScrollIndicator = false;
                
                inner.contentOffset = CGPointMake(offset*mySize.width,0);
                NSArray *data;
                for(int i = 0;i<[json[@"data"] count];i++){
                    data = ((NSArray *)json[@"data"])[i];
                    [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":data,@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height+49]],@"i":[NSString stringWithFormat:@"%d",i],@"scroller":inner} waitUntilDone:NO];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [scroller addSubview:inner];
                });
            }
        });
    }
    previndex = index;
}

@end
