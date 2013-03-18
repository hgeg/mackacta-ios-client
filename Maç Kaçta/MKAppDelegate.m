//
//  MKAppDelegate.m
//  Maç Kaçta
//
//  Created by  on 25.01.2013.
//  Copyright (c) 2013 Orkestra. All rights reserved.
//

#import "MKAppDelegate.h"

@implementation MKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"national"]){[[NSUserDefaults standardUserDefaults] setBool:false forKey:@"national"];
    }
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"]){
        UIViewController* mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"selection"];
        self.window.rootViewController = mainViewController;
    }else{
        UIViewController* mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"main"];
        self.window.rootViewController = mainViewController;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flags"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"active" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"active2" object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
