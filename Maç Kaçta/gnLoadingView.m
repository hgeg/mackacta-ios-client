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
        innerFrame = [[UIView alloc] initWithFrame:CGRectMake(140, 180, 60, 60)];
        innerFrame.backgroundColor = [UIColor colorWithRed:0.25 green:0.3 blue:0.35 alpha:0.8];
        innerFrame.layer.masksToBounds = YES;
        innerFrame.layer.cornerRadius = 10.0f;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 80, 20)];
        
        loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loader.frame = CGRectMake(10,10,40,40);
        //loader.backgroundColor = [UIColor redColor];
        [loader startAnimating];
        [loader setHidesWhenStopped:NO];
        
        [innerFrame addSubview:loader];
        [self addSubview:innerFrame];
    }
    return self;
}

- (void)calculateFrameWithMessage:(NSString *)message {
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:UILineBreakModeWordWrap];
    innerFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 60)];
    loader.frame = CGRectMake(10,10,60,60);
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
