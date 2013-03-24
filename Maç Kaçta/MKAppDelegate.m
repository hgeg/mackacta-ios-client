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
    [Parse setApplicationId:@"0wp0PrQU6fLrmTOiSmdv4A9AHeUyRQTEL6EhWpYb"
                  clientKey:@"v1Jmco9Ikrv4hxbu8WBsRY9HjR5PqAHoCat4HCal"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"national"]){[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"national"];
    }
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTeam"]){
        UIViewController* mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"selection"];
        self.window.rootViewController = mainViewController;
    }else{
        UIViewController* mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"main"];
        self.window.rootViewController = mainViewController;
    }
    application.applicationIconBadgeNumber = 0;
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] setValue:@"invalid" forKey:@"flags"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"active" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"active2" object:self];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setBadge:0];
    [currentInstallation saveInBackground];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
