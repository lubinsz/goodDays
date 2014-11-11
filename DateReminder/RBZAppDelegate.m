//
//  RBZAppDelegate.m
//  Date Reminder
//
//  Created by Xyz on 13-12-2.
//  Copyright (c) 2013年 Xyz Xyz. All rights reserved.
//

#import "RBZAppDelegate.h"
#import "RBZDateReminder.h"
#import "RBZSettingsViewController.h"
#import "MMDrawerController.h"
#import "RBZIAPHelper.h"
//#import "iRate.h"
#import "RBZDateReminderTest.h"

@interface RBZAppDelegate ()

@property RBZDateReminder *dateReminder;

@end

@implementation RBZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchWithOptions");
    
   // [RBZIAPHelper sharedInstance];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"dr.sqlite"];
#warning - Change to Prod settings before release
    //[GAI sharedInstance].trackUncaughtExceptions = YES;
    
    //bblu delete google analysis here..
   // [[GAI sharedInstance] trackerWithTrackingId:@"UA-47257351-2"]; // Dev: UA-47257351-2
    
    self.dateReminder = [RBZDateReminder instance];
    
    UINavigationController *root = (UINavigationController *)self.window.rootViewController;

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    UIViewController *settings = (UIViewController*)[sb instantiateViewControllerWithIdentifier:@"vc_settings"];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:root
                                                                           leftDrawerViewController:nil
                                                                          rightDrawerViewController:settings];
    drawerController.shouldStretchDrawer = NO;
    //[drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    [self.window setRootViewController:drawerController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"applicationWillTerminate");
    [MagicalRecord cleanUp];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
