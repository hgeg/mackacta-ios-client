//
//  MKMatchView.m
//  Maç Kaçta
//
//  Created by Ali Can Bülbül on 1/26/13.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKMatchView.h"
#define IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MKMatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (MKMatchView *) clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    MKMatchView *clone = (MKMatchView *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}

+ (MKMatchView *) generateWithObject:(NSDictionary *)dict week:(NSUInteger) weekValue size:(CGSize) mySize andOffset:(NSUInteger) i {
    int yOffset = 11;
    int yhOffset = 0;
    MKMatchView * newView = [[MKMatchView alloc] initWithFrame:CGRectMake(20+i*mySize.width, 20, mySize.width-40, mySize.height-40)];
    newView.backgroundColor = [UIColor colorWithRed:0.1 green:0.12 blue:0.12 alpha:0.7];
    newView.layer.masksToBounds = YES;
    newView.layer.cornerRadius = 4.0f;
    @try
    {
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 280, 21)];
        week.font = [UIFont systemFontOfSize:15];
        week.backgroundColor = [UIColor clearColor];
        week.textColor = [UIColor whiteColor];
        week.textAlignment = NSTextAlignmentCenter;
        BOOL cert = false;
        if([dict[@"league"] isEqualToString:@"sampiyonlar-ligi"]){
            week.text = @"Şampiyonlar Ligi";
            cert = true;
        }else if([dict[@"league"] isEqualToString:@"uefa-avrupa-ligi"]){
            week.text = @"UEFA Avrupa Ligi";
            cert = true;
        }else if([dict[@"league"] isEqualToString:@"dunya-kupasi-2014"]){
            week.text = @"Dünya Kupası 2014 - Avrupa Elemeleri";
            cert = true;
        }else
            week.text = [NSString stringWithFormat:@"Spor Toto Süper Lig %@. hafta",dict[@"week"]];
        [newView addSubview:week];
        yOffset += 35;
        if(!IPHONE_5) yhOffset = 10;
        
        UIImageView *homeTeamBrand = [[UIImageView alloc] initWithFrame:CGRectMake(5, yOffset, 120, 117-yhOffset)];
        homeTeamBrand.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-logo.png",dict[@"home"]]];
        [newView addSubview:homeTeamBrand];
        homeTeamBrand.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView *awayTeamBrand = [[UIImageView alloc] initWithFrame:CGRectMake(155, yOffset, 120, 117-yhOffset)];
        awayTeamBrand.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-logo.png",dict[@"away"]]];
        [newView addSubview:awayTeamBrand];
        awayTeamBrand.contentMode = UIViewContentModeScaleAspectFit;
        yOffset += 101;
        if(!IPHONE_5) yOffset -= 10;
    
        UILabel *homeTeamName = [[UILabel alloc] initWithFrame:CGRectMake(10, yOffset, 111, 66)];
        homeTeamName.userInteractionEnabled = false;
        homeTeamName.font = [UIFont boldSystemFontOfSize:17];
        homeTeamName.backgroundColor = [UIColor clearColor];
        homeTeamName.textColor = [UIColor whiteColor];
        homeTeamName.textAlignment = NSTextAlignmentCenter;
        homeTeamName.adjustsFontSizeToFitWidth = true;
        homeTeamName.text = dict[@"home"];
        [newView addSubview:homeTeamName];
        
        UILabel *awayTeamName = [[UILabel alloc] initWithFrame:CGRectMake(160, yOffset, 111, 66)];
        awayTeamName.userInteractionEnabled = false;
        awayTeamName.font = [UIFont boldSystemFontOfSize:17];
        awayTeamName.backgroundColor = [UIColor clearColor];
        awayTeamName.textColor = [UIColor whiteColor];
        awayTeamName.textAlignment = NSTextAlignmentCenter;
        awayTeamName.adjustsFontSizeToFitWidth = true;
        awayTeamName.text = dict[@"away"];
        [newView addSubview:awayTeamName];
        yOffset += 123;
        
        if(!IPHONE_5) yOffset -= 60;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yy HH:mm"];
        NSDate *d = [dateFormat dateFromString:dict[@"d"]];
    
        if([d timeIntervalSinceNow]<-5400){
            UILabel *homeTeamScore = [[UILabel alloc] initWithFrame:CGRectMake(43, yOffset, 37, 38)];
            homeTeamScore.font = [UIFont boldSystemFontOfSize:43];
            homeTeamScore.backgroundColor = [UIColor clearColor];
            homeTeamScore.textColor = [UIColor whiteColor];
            homeTeamScore.textAlignment = NSTextAlignmentCenter;
            homeTeamScore.text = dict[@"sh"];
            [newView addSubview:homeTeamScore];
            
            UILabel *awayTeamScore = [[UILabel alloc] initWithFrame:CGRectMake(196, yOffset, 37, 38)];
            awayTeamScore.font = [UIFont boldSystemFontOfSize:43];
            awayTeamScore.backgroundColor = [UIColor clearColor];
            awayTeamScore.textColor = [UIColor whiteColor];
            awayTeamScore.textAlignment = NSTextAlignmentCenter;
            awayTeamScore.text =dict[@"sa"];
            [newView addSubview:awayTeamScore];
            
            UILabel *dash = [[UILabel alloc] initWithFrame:CGRectMake(123, yOffset-7, 34, 51)];
            dash.font = [UIFont systemFontOfSize:45];
            dash.backgroundColor = [UIColor clearColor];
            dash.textColor = [UIColor whiteColor];
            dash.textAlignment = NSTextAlignmentCenter;
            dash.text = @"-";
            [newView addSubview:dash];
            yOffset += 79;
        }else if(!IPHONE_5) yOffset += 40;
        if(!IPHONE_5) yOffset -= 20;
        
        NSLocale *tr = [[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR"];
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEE, dd MMMM yyyy" options:0 locale:tr];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateFormat:formatString];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* comp1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:d]; // Get necessary date components
        NSDateComponents* comp2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]]; // Get necessary date components
        
        NSString *dateString;
        if(comp1.year == comp2.year && comp1.month==comp2.month) {
            if (comp1.day == comp2.day) {
                dateString = @"Bugün";
            }else if(comp1.day == comp2.day+1){
                dateString = @"Yarın";
            }else if(comp1.day == comp2.day-1){
                dateString = @"Dün";
            }else dateString = [dateFormatter stringFromDate:d];
        }else dateString = [dateFormatter stringFromDate:d];
        
        NSLog(@"%d",comp1.hour);
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, 280, 21)];
        date.font = [UIFont boldSystemFontOfSize:17];
        date.backgroundColor = [UIColor clearColor];
        date.textColor = [UIColor whiteColor];
        date.textAlignment = NSTextAlignmentCenter;
        [newView addSubview:date];
        NSString *timeString;
        
        if(((comp1.hour==0 || comp1.hour==2) && comp1.minute==0)) {
            timeString = @"--:--";
            dateString = @"Tarih belli değil";
        }
        
        date.text = dateString;
        
        yOffset += 23;
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, 280, 21)];
        time.font = [UIFont boldSystemFontOfSize:17];
        time.backgroundColor = [UIColor clearColor];
        time.textColor = [UIColor whiteColor];
        time.textAlignment = NSTextAlignmentCenter;
        time.text = timeString;
        [newView addSubview:time];
        yOffset += 34;
        
        UILabel *stage = [[UILabel alloc] initWithFrame:CGRectMake(5, yOffset, 270, 21)];
        stage.font = [UIFont systemFontOfSize:17];
        stage.backgroundColor = [UIColor clearColor];
        stage.textColor = [UIColor whiteColor];
        stage.textAlignment = NSTextAlignmentCenter;
        if([dict[@"stage"] isEqualToString:@""])
            stage.text = @"";
        else if([dict[@"stage"] rangeOfString:@"Arena"].location == NSNotFound &&
           [dict[@"stage"] rangeOfString:@"Stadı"].location == NSNotFound &&
           [dict[@"stage"] rangeOfString:@"Stadyumu"].location == NSNotFound)
            stage.text = [NSString stringWithFormat:@"%@ Stadyumu",dict[@"stage"]];
        else
            stage.text = dict[@"stage"];
        [newView addSubview:stage];
        stage.adjustsFontSizeToFitWidth = true;
        yOffset += 22;
        
        UILabel *channel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, 280, 21)];
        channel.font = [UIFont systemFontOfSize:17];
        channel.backgroundColor = [UIColor clearColor];
        channel.textColor = [UIColor whiteColor];
        channel.textAlignment = NSTextAlignmentCenter;
        if([dict[@"league"] isEqualToString:@"sampiyonlar-ligi"])
            channel.text = @"Star TV";
        else
            channel.text = @"Lig TV";
        [newView addSubview:channel];
        
    }
    @catch (NSException *exception) {NSLog(@"%@",exception);}
    return newView;
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
