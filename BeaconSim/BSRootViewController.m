//
//  BSRootViewController.m
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

#import "BSRootViewController.h"
#import "BSBeaconSimulator.h"

@interface BSRootViewController ()

@property (weak, nonatomic) IBOutlet UILabel *UUIDLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

- (IBAction)toggleBeacon:(id)sender;

@end

@implementation BSRootViewController

#pragma mark BSRootViewController Private

- (IBAction)toggleBeacon:(id)sender;
{
    if ( self.toggleSwitch.on ) {
        [self.simulator start:self];
    } else {
        [self.simulator stop:self];
    }
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    NSAssert( self.simulator != nil, @"simulator should be set" );

    [super viewDidLoad];

    self.UUIDLabel.text = self.simulator.UUID.UUIDString;
    self.toggleSwitch.on = YES;
}

@end