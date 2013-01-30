//
//  MKSecondViewController.h
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKStandingsController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

{
    NSArray *teams;
    BOOL loading;
}
@property (weak, nonatomic) IBOutlet UICollectionView *table;
@end
