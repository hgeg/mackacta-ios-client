//
//  gnLoadingView.h
//  gonna_test
//
//  Created by Ali Can Bülbül on 10/31/12.
//  Copyright (c) 2012 Gonnasphere.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface gnLoadingView : UIView
{
    UIView *innerFrame;
    UIActivityIndicatorView *loader;
    UILabel *label;
}

- (id)initWithFrame:(CGRect)frame label:(NSString *)message;

+ (gnLoadingView *)showOnView:(UIView *)view;

+ (gnLoadingView *)show:(NSString *)message onView:(UIView *)view;

+ (id)hideLoader:(gnLoadingView *)loading;
+ (id)hideLoader;

+ (gnLoadingView *) getInstance;

@end
