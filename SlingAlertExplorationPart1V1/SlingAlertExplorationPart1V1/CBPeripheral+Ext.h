//
//  CBPeripheral+Ext.h
//  BeanAlertExplorationV2
//
//  Created by Margaret Johnson on 1/6/15.
//  Copyright (c) 2015 Margaret Johnson. All rights reserved.
//

#ifndef BeanAlertExplorationV2_CBPeripheral_Ext_h
#define BeanAlertExplorationV2_CBPeripheral_Ext_h
@import CoreBluetooth;
@interface CBPeripheral(Ext)

- (void)showInfo:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
@end


#endif
