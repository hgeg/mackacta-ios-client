//
//  gnLoadingView.m
//  gonna_test
//
//  Created by Ali Can Bülbül on 10/31/12.
//  Copyright (c) 2012 Gonnasphere.com. All rights reserved.
//

#import "gnLoadingView.h"

@implementation gnLoadingView

static gnLoadingView *_default = nil;

+ (gnLoadingView *) getInstance
{
    if (_default == nil) {
        _default = [[gnLoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) label:@"Loading"];
    }
    return _default;
}


- (id)initWithFrame:(CGRect)frame label:(NSString *)message
{
    self = [super initWithFrame:frame];
    if (self) {
        innerFrame = [[UIView alloc] initWithFrame:CGRectMake(140, 180, 40, 40)];
        innerFrame.backgroundColor = [UIColor colorWithRed:0.25 green:0.3 blue:0.35 alpha:0.8];
        innerFrame.layer.masksToBounds = YES;
        innerFrame.layer.cornerRadius = 10.0f;
        
        loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loader.frame = CGRectMake(0,0,40,40);
        //loader.backgroundColor = [UIColor redColor];
        [loader startAnimating];
        [loader setHidesWhenStopped:NO];
        
        [innerFrame addSubview:loader];
        [self addSubview:innerFrame];
    }
    return self;
}

- (void)calculateFrameWithMessage:(NSString *)message {
    innerFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 180, 320, 60)];
    loader.frame = CGRectMake(0,0,40,40);
}

- (void) setLabel:(NSString *)message {
    label.text = message;
}

- (UILabel *) getLabel {
    return label;
}

+ (gnLoadingView *)showOnView:(UIView *)view {
    gnLoadingView *loading = [gnLoadingView getInstance];
    [loading setLabel:@"Loading"];
    loading.alpha = 0;
    [view addSubview:loading];
    [view bringSubviewToFront:loading];
    @try {
        [UIView animateWithDuration:0.1 animations:^{
            loading.alpha = 1;
        }];
    }
    @catch (NSException *exception) {
        gnLoadingView *loading = [gnLoadingView getInstance];
        [UIView animateWithDuration:0.1 animations:^{
            loading.alpha = 1;
        }];
    }
    return loading;
}

+ (gnLoadingView *)show:(NSString *)message onView:(UIView *)view {
    gnLoadingView *loading = [gnLoadingView getInstance];
    [loading setLabel:message];
    [loading calculateFrameWithMessage:message];
    loading.alpha = 0;
    [view addSubview:loading];
    [view bringSubviewToFront:loading];
    [UIView animateWithDuration:0.1 animations:^{
        loading.alpha = 1;
    }];
    return loading;
}



+ (id)hideLoader:(gnLoadingView *)loading {
    [UIView animateWithDuration:0.1 animations:^{
        loading.alpha = 0;
    }];
    //[loading removeFromSuperview];
    return loading;
}

+ (id)hideLoader {
    @try{
        gnLoadingView *loading = [gnLoadingView getInstance];
        [UIView animateWithDuration:0.1 animations:^{
            loading.alpha = 0;
        }];
        [loading removeFromSuperview];
        return loading;
    }@catch (NSException *e) {return nil;}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
