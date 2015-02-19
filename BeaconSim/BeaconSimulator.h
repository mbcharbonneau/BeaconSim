//
//  BeaconSimulator.h
//  BeaconSim
//
//  Created by mbcharbonneau on 2/18/15.
//  Copyright (c) 2015 Geoloqi. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import CoreBluetooth;

@interface BeaconSimulator : NSObject

@property (readonly) NSUUID *UUID;

- (instancetype)initWithUUID:(NSUUID *)UUID;

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;

@end
