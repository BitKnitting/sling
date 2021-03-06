//
//  CBCentralManager+Ext.m
//  Vicinity
//
//  Created by Ben Ford on 11/12/13.
//  
//  The MIT License (MIT)
// 
//  Copyright (c) 2013 Instrument Marketing Inc
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

#define LOG
#define LOG_DEBUG
#import "CBCentralManager+Ext.h"

@implementation CBCentralManager(Ext)
- (NSString *)stateString
{
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif

    switch (self.state) {
        case CBCentralManagerStatePoweredOff:
            return @"Powered Off";
            break;
            
        case CBCentralManagerStateResetting:
            return @"Resetting";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return @"Powered On";
            break;
            
        case CBCentralManagerStateUnauthorized:
            return @"Unauthorized";
            break;
            
        case CBCentralManagerStateUnknown:
            return @"Unknown";
            break;
            
        case CBCentralManagerStateUnsupported:
            return @"Unsupported";
            break;
    }
}
- (void) startScan:(CBUUID *)uuidPtr
{
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
#ifdef LOG_DEBUG
    NSLog(@"Scanning ONLY happens when Core Bluetooth returns a state of Powered On");
    NSLog(@"State: %@",self.stateString);
#endif

    if (self.state == CBCentralManagerStatePoweredOn) {
        NSArray *services = [NSArray arrayWithObject:uuidPtr];
        [self stopScan];
#ifdef LOG_DEBUG
        NSLog(@"Scanning has stopped");
#endif
        [self scanForPeripheralsWithServices:services options:nil];
#ifdef LOG_DEBUG
        NSLog(@"Scanning has started");
#endif
    }
}

@end
