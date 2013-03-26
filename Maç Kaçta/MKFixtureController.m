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
    
    _accountStore = [[ACAccountStore alloc] init];
    
    queue = dispatch_queue_create("com.orkestra.mackacta.fixturequeue", nil);
    liveq = [[NSOperationQueue alloc] init];
    scroller.delegate = self;
    gLock = 2;
    offset = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preChange) name:@"active" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:@"active2" object:nil];
}

-(void) preChange {
    [gnLoadingView showOnView:self.view];
    [self.scroller removeFromSuperview];
    self.fbShare.alpha = 0;
    self.twShare.alpha = 0;
}

-(void) viewDidAppear:(BOOL)animated {
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqualToString:@"valid"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flags"];
        offset = 0;
        self.fbShare.alpha = 0;
        self.twShare.alpha = 0;
        
        // Do any additional setup after loading the view, typically from a nib.
        CGSize mySize = self.view.frame.size;
        self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mySize.width, mySize.height)];
        self.scroller.delegate = self;
        self.scroller.pagingEnabled = true;
        [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.background.alpha = 0.0;
        [UIView commitAnimations];
        myTeam = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"];
        
        // When users indicate they are Giants fans, we subscribe them to that channel.
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:[[NSString alloc] initWithData:[myTeam dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding] forKey:@"channels"];
        [currentInstallation saveInBackground];
        
        self.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-bg.jpg",myTeam]];
        [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.background.alpha = 1.0;
        [UIView commitAnimations];
        NSURL *URL;
        NSDictionary *json;
        @try {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"national"])
                URL = [NSURL URLWithString:[[NSString stringWithFormat:@"http://54.235.244.172/api/v1_0/match/%@/nationals:yes/",myTeam] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            else
                URL = [NSURL URLWithString:[[NSString stringWithFormat:@"http://54.235.244.172/api/v1_0/match/%@/",myTeam] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
             json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
        }
        @catch (NSException *exception) {
            [gnLoadingView hideLoader];
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
            newView.backgroundColor = [UIColor colorWithRed:0.1 green:0.12 blue:0.12 alpha:0.7];
            newView.layer.masksToBounds = YES;
            newView.layer.cornerRadius = 4.0f;
            UILabel *errTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 280, 30)];
            errTitle.text = @"Bağlantı Hatası!";
            errTitle.textAlignment = NSTextAlignmentCenter;
            errTitle.textColor = [UIColor whiteColor];
            errTitle.backgroundColor = [UIColor clearColor];
            errTitle.font = [UIFont boldSystemFontOfSize:18];
            [newView addSubview:errTitle];
            
            UITextView *errMsg = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, 260, 150)];
            errMsg.text = @"Geçerli bir internet bağlantısı bulunamadı. Lütfen bağlantınızı kontrol edin.";
            errMsg.textAlignment = NSTextAlignmentCenter;
            errMsg.textColor = [UIColor whiteColor];
            errMsg.backgroundColor = [UIColor clearColor];
            errMsg.font = [UIFont systemFontOfSize:14];
            errMsg.editable = false;
            [newView addSubview:errMsg];
            
            UIButton *refButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 140, 60, 30)];
            refButton.imageView.image = [UIImage imageNamed:@"twitter_share.png"];
            [newView addSubview:refButton];
            
            [scroller addSubview:newView];
            [self.matchView removeFromSuperview];
            [self.view addSubview:scroller];
            return;
        }
       
        data = json[@"data"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yy HH:mm"];
        int k = 0;
        for (int i = 0; i<[data count]; i++) {
            dispatch_async(queue, ^{
                [self performSelectorOnMainThread:@selector(generateView:) withObject:@{@"json":data[i],@"mySize":@[[NSString stringWithFormat:@"%f",mySize.width],[NSString stringWithFormat:@"%f",mySize.height]],@"i":[NSString stringWithFormat:@"%d",i ],@"scroller":scroller} waitUntilDone:NO];
            });
            if(k==0 && [[[dateFormat dateFromString:data[i][@"d"]] dateByAddingTimeInterval:60*100] compare:[NSDate date]]==(NSOrderedDescending|NSOrderedSame)){
                k=i;
            }
        }
        [self.matchView removeFromSuperview];
        [self.view addSubview:self.scroller];
        self.scroller.showsHorizontalScrollIndicator = false;
        [[NSUserDefaults standardUserDefaults] setValue:@"valid" forKey:@"flag"];
        self.scroller.contentSize = CGSizeMake(mySize.width*[data count], mySize.height);
        [self.scroller setContentOffset:CGPointMake(k*320, 0)];
        [self.view bringSubviewToFront:self.twShare];
        [self.view bringSubviewToFront:self.fbShare];
    }
    dispatch_sync(queue, ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
            self.background.alpha = 1.0;
            self.fbShare.alpha = 1;
            self.twShare.alpha = 1;
        [UIView commitAnimations];
        [gnLoadingView hideLoader];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateMatches];
    });
}

- (void)generateView:(NSObject *)pobj {
    NSDictionary *params = (NSDictionary *)pobj;
    MKMatchView *newView = [MKMatchView generateWithObject:params[@"json"] week:nextweek size:CGSizeMake([params[@"mySize"][0] floatValue], [params[@"mySize"][1] floatValue]) andOffset:[params[@"i"] intValue]];
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

-(IBAction)twitter:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            //if (result == SLComposeViewControllerResultCancelled) {} else{}
            [UIView animateWithDuration:0.2 animations:^{
                self.fbShare.alpha = 1;
                self.twShare.alpha = 1;
            }];
            [controller dismissViewControllerAnimated:YES completion:nil];
        };
        controller.completionHandler = myBlock;
        
        self.fbShare.alpha = 0;
        self.twShare.alpha = 0;
        
        if([data[(int)(scroller.contentOffset.x/320)][@"home"] isEqualToString:@"Türkiye"] || [data[(int)(scroller.contentOffset.x/320)][@"away"] isEqualToString:@"Türkiye"])
            [controller setInitialText:[NSString stringWithFormat:@"#Türkiyem @mackactanet "]];
        else
            [controller setInitialText:[NSString stringWithFormat:@"#%@ @mackactanet ",myTeam]];
        //[controller addURL:[NSURL URLWithString:@"http://www.google.com"]];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, self.view.frame.size.height-40),NO,0.0);
        [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [controller addImage:image];
        [self presentViewController:controller animated:YES completion:nil];
    }
}


-(IBAction)facebook:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            //if (result == SLComposeViewControllerResultCancelled) {} else{}
            [UIView animateWithDuration:0.2 animations:^{
                self.fbShare.alpha = 1;
                self.twShare.alpha = 1;
            }];
            [controller dismissViewControllerAnimated:YES completion:nil];
        };
        controller.completionHandler = myBlock;
        
        self.fbShare.alpha = 0;
        self.twShare.alpha = 0;
        
        [controller setInitialText:@""];
        //[controller addURL:[NSURL URLWithString:@"http://www.google.com"]];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, self.view.frame.size.height-40),NO,0.0);
        [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(16, 16, 288, self.view.frame.size.height-32))];
        UIGraphicsEndImageContext();
        [controller addImage:image];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)updateMatches{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lslock"]) return;
    __block UIActivityIndicatorView *aiw = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    dispatch_async(dispatch_get_main_queue(), ^{
        aiw.frame = CGRectMake(148, 150, 20, 20);
        [aiw startAnimating];
        [self.view addSubview:aiw];
    });
    NSLog(@"update started");
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"lslock"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://54.235.244.172/api/v1_0/scores:live/"]];
    [NSURLConnection sendAsynchronousRequest:request queue:liveq completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *err) {
        if (responseData){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            NSArray *d = json[@"data"];
            for(int i=0;i<[d count];i++){
                @try {
                    [((MKMatchView *)[self.scroller viewWithTag:[d[i][@"id"] integerValue]]) updateMatchminutes:d[i][@"c"] homeScore:d[i][@"sh"] andAwayScore:d[i][@"sa"]];
                }
                @catch (NSException *exception) {}
            }
        }
        NSLog(@"updated");
        dispatch_async(dispatch_get_main_queue(), ^{
            [aiw removeFromSuperview];
            aiw=nil;
        });
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"lslock"];
        
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, queue, ^(void){
            [self updateMatches];
        });
    }];
}

@end