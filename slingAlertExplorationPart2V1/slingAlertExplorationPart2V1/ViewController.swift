//
//  ViewController.swift
//  slingAlertExplorationPart2V1
//
//  Created by Margaret Johnson on 1/8/15.
//  Copyright (c) 2015 Margaret Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BeaconDelegate,BTDiscoveryDelegate{
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        iBeaconProximity.delegate = self
        btDiscovery.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: BeaconDelegate callback
    func beaconDidUpdate(proximity:String,accuracy:String,rssi:String) {
        proximityLabel.text = proximity
        accuracyLabel.text = accuracy
        rssiLabel.text = rssi
        var message = "beaconDidUpdate...Proximity : "
        message += proximity
        message += " Accuracy: "
        message += accuracy
        message += " RSSI: "
        message += rssi
        println(message)
    }
    //MARK: BTDiscoveryDelegate callback
    //Once an alert has been discovered, the app runs in the foreground.  the SlingDidAlert delegate is called.  
    //start scanning for the sling device as a Beacon.
    func slingDidAlert() {
        println("Sling discovered an alert")
        iBeaconProximity.startScanning()
    }
}

