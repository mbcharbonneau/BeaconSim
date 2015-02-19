//
//  ViewController.m
//  BeaconSim
//
//  Created by mbcharbonneau on 2/18/15.
//  Copyright (c) 2015 Geoloqi. All rights reserved.
//

#import "ViewController.h"
#import "BeaconSimulator.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *UUIDLabel;
@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch;

- (IBAction)toggleBeacon:(id)sender;

@end

@implementation ViewController

- (IBAction)toggleBeacon:(id)sender;
{
    if ( self.toggleSwitch.on ) {
        [self.simulator start:self];
    } else {
        [self.simulator stop:self];
    }
}

- (void)viewDidLoad;
{
    NSAssert( self.simulator != nil, @"simulator should be set" );

    [super viewDidLoad];

    self.UUIDLabel.text = self.simulator.UUID.UUIDString;
    self.toggleSwitch.on = YES;
}

@end
