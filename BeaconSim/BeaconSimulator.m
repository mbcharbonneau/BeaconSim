//
//  BeaconSimulator.m
//  BeaconSim
//
//  Created by mbcharbonneau on 2/18/15.
//  Copyright (c) 2015 Geoloqi. All rights reserved.
//

#import "BeaconSimulator.h"

@interface BeaconSimulator() <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (assign, nonatomic) BOOL shouldBroadcast;

- (void)beginAdvertising;

@end

@implementation BeaconSimulator

#pragma mark BeaconSimulator

- (instancetype)initWithUUID:(NSUUID *)UUID;
{
    NSParameterAssert( UUID != nil );

    if ( self = [super init] ) {

        _UUID = UUID;
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        _shouldBroadcast = NO;
    }

    return self;
}

- (IBAction)start:(id)sender;
{
    self.shouldBroadcast = YES;
    if ( self.peripheralManager.state == CBPeripheralManagerStatePoweredOn ) {
        [self beginAdvertising];
    }
}

- (IBAction)stop:(id)sender;
{
    self.shouldBroadcast = NO;
    [self.peripheralManager stopAdvertising];
}

#pragma mark BeaconSimulator Private

- (void)beginAdvertising;
{
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.UUID major:2 minor:1 identifier:self.UUID.UUIDString];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];

    [self.peripheralManager startAdvertising:beaconPeripheralData];
}

#pragma mark NSObject

- (void)dealloc;
{
    [self stop:self];
}

#pragma mark CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral;
{
    if ( peripheral.state != CBPeripheralManagerStatePoweredOn ) {
        return;
    }

    NSLog( @"CBPeripheralManager powered on!" );

    if ( self.shouldBroadcast ) {
        [self beginAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error;
{
    if ( error ) {
        NSLog( @"CBPeripheralManager error: %@", [error debugDescription] );
    } else {
        NSLog( @"CBPeripheralManager did start advertising." );
    }
}

@end
