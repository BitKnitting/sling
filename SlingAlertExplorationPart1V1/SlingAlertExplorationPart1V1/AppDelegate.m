//
//  AppDelegate.m
//  BeanAlertExplorationV2
//
//  Created by Margaret Johnson on 1/5/15.
//  Copyright (c) 2015 Margaret Johnson. All rights reserved.
//
#define LOG
#define LOG_DEBUG
#import "AppDelegate.h"
#import "CBCentralManager+Ext.h"
#import "CBPeripheral+Ext.h"
////////////////////////////////////////////////////////////
// all Beans have the UUID A495FF10-C5B1-4B44-B512-1370F02D74DE
////////////////////////////////////////////////////////////
NSString *const kBeanUuid = @"A495FF10-C5B1-4B44-B512-1370F02D74DE";
@interface AppDelegate ()
@property (strong,nonatomic)   CBCentralManager *manager;
@property (strong,nonatomic)   CBPeripheral *sling;
////////////////////////////////////////////////////////////
// runningInBackground is used in centralManagerDidUpdateState:
// - the device's bluetooth state is updated when the central manager object is initiated and when bluetooth is
//   turned on/off from outside an app.
// - if update happens when the device is in the foreground and the Bean is detected, there is no way to
//   discover the bean in the background even if scanning is stopped and restarted.
//   It seems the bluetooth cache is holding on to the scanning info - stopping scanning or setting the central manager
//   to nil doesn't affect the cache.
////////////////////////////////////////////////////////////
@property (getter=isRunningInBackground) BOOL runningInBackground;
@property UIUserNotificationType notificationTypes;
@property (strong,nonatomic)UIUserNotificationSettings *notificationSettings;

@end

@implementation AppDelegate

#
#pragma mark - AppDelegate Callbacks
#

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
#ifdef LOG_DEBUG
    NSLog(@"Initializing the central manager");
    NSLog(@"Registering to send UI notifications");
#endif
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.runningInBackground = false;
    self.notificationTypes = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    self.notificationSettings = [UIUserNotificationSettings settingsForTypes:self.notificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:self.notificationSettings];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
    NSString *connectedString = [NSString stringWithFormat:@"Connected: %@", self.sling.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
     NSLog(@"%@", connectedString);
    

#endif
    
    self.runningInBackground = true;
    [self.manager startScan:[CBUUID UUIDWithString:kBeanUuid]];
    self.manager.delegate = self;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
}
#
#pragma mark - CentralManagerDelegate Callbacks
#
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
#ifdef LOG_DEBUG
    NSLog(@"Core Bluetooth state: %@",self.manager.stateString);
#endif
    if (self.isRunningInBackground){
        [self.manager startScan:[CBUUID UUIDWithString:kBeanUuid]];
        self.manager.delegate = self;
    }
}
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
#ifdef LOG
    NSLog(@"===========================================");
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
#endif
    self.sling = aPeripheral;
    
#ifdef LOG_DEBUG
    [self.sling showInfo:advertisementData RSSI:RSSI];
    NSLog(@"Scanning Stopped");
#endif
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
#ifdef LOG_DEBUG
    NSLog(@"sling's name: %@",localName);
#endif
    if ([localName isEqualToString:@"HELP" ]) {
#ifdef LOG_DEBUG
        NSLog(@"alert is being sent");
#endif
        UILocalNotification *slingNotification = [[UILocalNotification alloc]init];
        slingNotification.soundName= @"Siren_Noise-KevanGC-1337458893.caf";
        slingNotification.alertBody = @"SLING ALERT";
        slingNotification.alertAction = @"HELP!";
        slingNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication]scheduleLocalNotification:slingNotification];
        
    }
    [self.manager stopScan];
}

@end
