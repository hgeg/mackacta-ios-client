//
//  MKMatchView.h
//  Maç Kaçta
//
//  Created by Ali Can Bülbül on 1/26/13.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MKMatchView : UIView
{
    NSString *timeStr;
}
- (MKMatchView *) clone;
+ (MKMatchView *) generateWithObject:(NSDictionary *)dict week:(NSUInteger) week size:(CGSize) mySize andOffset:(NSUInteger) i;

- (int) updateMatchminutes:(NSString *)mins homeScore:(NSString *)h andAwayScore:(NSString *)a;

@end
