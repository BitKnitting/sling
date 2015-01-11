//
//  BTDiscovery.swift
//  Arduino_Servo
//
//  Created by Owen L Brown on 9/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//
import UIKit
import Foundation
import CoreBluetooth
let btDiscovery = BTDiscovery()
let BeanPeripheralUUID = CBUUID(string: "A495FF10-C5B1-4B44-B512-1370F02D74DE")
var runningInBackground = false

protocol BTDiscoveryDelegate {
    func slingDidAlert()
}
class BTDiscovery: NSObject, CBCentralManagerDelegate {
  
  let centralManager: CBCentralManager?
  var delegate:BTDiscoveryDelegate? = nil
  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
    // MARK:CBCentralManagerDelegate Callbacks
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch central.state {
        case CBCentralManagerState.PoweredOff:
            break
            
        case CBCentralManagerState.Unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case CBCentralManagerState.Unknown:
            // Wait for another event
            break
            
        case CBCentralManagerState.PoweredOn:
            if runningInBackground {
                self.startScanning()
            }
            
        case CBCentralManagerState.Resetting:
            break
            
        case CBCentralManagerState.Unsupported:
            break
            
        default:
            break
        }
    }
  func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
    println("Peripheral found: \(peripheral)");
    printDetails(advertisementData)
    // Validate peripheral information
    if peripheral == nil  {
      return
    }
    sendAlert();
  }
  // MARK: - Functions
    func startScanning() {
        println("Stop scan")
        centralManager?.stopScan()
        println("start scan")
        if let central = centralManager {
            central.scanForPeripheralsWithServices([BeanPeripheralUUID], options: nil)
        }
    }
    func stopScanning() {
        println("Stop scan")
        centralManager?.stopScan()
    }
    func printDetails(advertisementData: [NSObject : AnyObject]!) {
        for (myKey,myValue) in advertisementData {
            println("key: \(myKey) value: \(myValue) ")
        }
    }
    func sendAlert() {
        var notification = UILocalNotification()
        notification.fireDate = NSDate.init()
        notification.alertBody = "SLING ALERT"
        notification.alertAction = "HELP!"
        // MARK: TBD: HOOK IN NOTIFICATION SOUND
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        if (delegate != nil) {
            delegate!.slingDidAlert()
        }
    }
    func requestToSendAlert() {
        let requestedTypes = UIUserNotificationType.Alert | .Sound
        let settingsRequest = UIUserNotificationSettings(forTypes:requestedTypes, categories:nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settingsRequest)
    }
}
