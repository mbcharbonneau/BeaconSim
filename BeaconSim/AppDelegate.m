//
//  AppDelegate.m
//  BeaconSim
//
//  Created by mbcharbonneau on 2/18/15.
//  Copyright (c) 2015 Geoloqi. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconSimulator.h"
#import "ViewController.h"

static NSString *const BSUUIDKey = @"BSUUIDKey";

@interface AppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) BeaconSimulator *beaconSimulator;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
    NSString *UUIDString = [[NSUserDefaults standardUserDefaults] stringForKey:BSUUIDKey];
    NSUUID *UUID;

    if ( [UUIDString length] == 0 ) {
        UUID = [NSUUID UUID];
        [[NSUserDefaults standardUserDefaults] setObject:UUID.UUIDString forKey:BSUUIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        UUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
    }

    self.beaconSimulator = [[BeaconSimulator alloc] initWithUUID:UUID];

    if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse ) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self.beaconSimulator start:self];
    }

    ViewController *controller = (ViewController *)self.window.rootViewController;
    controller.simulator = self.beaconSimulator;

    return YES;
}

#pragma mark NSApplicationDelegate

- (void)applicationWillResignActive:(UIApplication *)application;
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application;
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application;
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application;
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application;
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    NSLog( @"Authorization changed!" );
    [self.beaconSimulator start:self];
}

@end
