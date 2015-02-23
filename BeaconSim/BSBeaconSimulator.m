//
//  BSBeaconSimulator.m
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

#import "BSBeaconSimulator.h"

@interface BSBeaconSimulator() <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (assign, nonatomic) BOOL shouldBroadcast;

- (void)beginAdvertising;

@end

@implementation BSBeaconSimulator

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
