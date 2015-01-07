//
//  CBPeripheral+Ext.m
//  BeanAlertExplorationV2
//
//  Created by Margaret Johnson on 1/6/15.
//  Copyright (c) 2015 Margaret Johnson. All rights reserved.
//
#define LOG
#import "CBPeripheral+Ext.h"

@implementation CBPeripheral(Ext)

-(void) showInfo:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
    NSLog(@"Peripheral: %@",self);
    NSLog(@"RSSI:       %@",RSSI);
    NSArray *keys = [advertisementData allKeys];
    for (int i = 0; i < [keys count]; ++i) {
        id key = [keys objectAtIndex: i];
        NSString *keyName = (NSString *) key;
        NSObject *value = [advertisementData objectForKey: key];
        if ([value isKindOfClass: [NSArray class]]) {
            printf("   key: %s\n", [keyName cStringUsingEncoding: NSUTF8StringEncoding]);
            NSArray *values = (NSArray *) value;
            for (int j = 0; j < [values count]; ++j) {
                if ([[values objectAtIndex: j] isKindOfClass: [CBUUID class]]) {
                    CBUUID *uuid = [values objectAtIndex: j];
                    NSData *data = uuid.data;
                    printf("      uuid(%d):", j);
                    for (int j = 0; j < data.length; ++j)
                        printf(" %2X", ((UInt8 *) data.bytes)[j]);
                    printf("\n");
                } else {
                    const char *valueString = [[value description] cStringUsingEncoding: NSUTF8StringEncoding];
                    printf("      value(%d): %s\n", j, valueString);
                }
            }
        } else {
            const char *valueString = [[value description] cStringUsingEncoding: NSUTF8StringEncoding];
            printf("   key: %s, value: %s\n", [keyName cStringUsingEncoding: NSUTF8StringEncoding], valueString);
        }
    }


    
}
@end