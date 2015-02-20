//
//  AppDelegate.m
//  BeaconSim
//
//  Created by mbcharbonneau on 2/18/15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Marc Charbonneau
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "AppDelegate.h"
#import "BeaconSimulator.h"
#import "RootViewController.h"

static NSString *const BSUUIDKey = @"BSUUIDKey";

@interface AppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) BeaconSimulator *beaconSimulator;

@end

@implementation AppDelegate

#pragma mark NSApplicationDelegate

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

    RootViewController *controller = (RootViewController *)self.window.rootViewController;
    controller.simulator = self.beaconSimulator;

    return YES;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    NSLog( @"Authorization changed!" );
    [self.beaconSimulator start:self];
}

@end
