//
//  IBeaconProximity.swift
//
//  Created by Margaret Johnson 2015
//  Copyright (c) 2015 Margaret Johnson All rights reserved.
//
import UIKit
import Foundation
import CoreLocation
let iBeaconProximity = IBeaconProximity()
let beaconUUIDString = "A4951234-C5B1-4B44-B512-1370F02D74DE"
let beaconName = "HELP"
let beaconUUID:NSUUID = NSUUID(UUIDString:beaconUUIDString)!

protocol BeaconDelegate {
    func beaconDidUpdate(proximity:String,accuracy:String,rssi:String)
}


class IBeaconProximity: NSObject, CLLocationManagerDelegate {
    let myBeaconManager: CLLocationManager!
    var delegate:BeaconDelegate? = nil
    override init() {
        super.init()
        myBeaconManager = CLLocationManager()
        if myBeaconManager!.respondsToSelector("requestAlwaysAuthorization"){
            myBeaconManager!.requestAlwaysAuthorization()
        }
        myBeaconManager!.delegate = self

    }
    // MARK: CLLocationManagerDelegate Callbacks
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("DidStartMonitoringForRegion")
    }
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println("didRangeBeacons")
        if (delegate  != nil) {
            var proximity = "Uninitialized"
            let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                proximity = "Far"
            case CLProximity.Near:
                proximity = "Near"
            case CLProximity.Immediate:
                proximity = "Immediate"
            case CLProximity.Unknown:
                proximity = "Unknown"
            default:
                proximity = "Not Found"
            }
            let accuracy = NSString(format:"%.2f",nearestBeacon.accuracy)
            let rssi =  NSString(format:"%ld",nearestBeacon.rssi)
            delegate!.beaconDidUpdate(proximity,accuracy:accuracy,rssi: rssi)
        }
    }
   // MARK: - Functions
    func startScanning() {
        println(beaconName);
        println(beaconUUID);
        let region = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconName)
        println(region)
        println("start startMonitoringForRegion")
        myBeaconManager.startMonitoringForRegion(region)
        println("startRangingBeaconsInRegion")
        myBeaconManager.startRangingBeaconsInRegion(region)
    }
}
