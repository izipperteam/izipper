//
//  FirstViewController.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    var bluetoothDiscovery: IZDiscovery?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("bluetoothStatusChanged:"), name: kBLEServiceChangedStatusNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectButtonPressed(sender: AnyObject) {
        bluetoothDiscovery = IZDiscovery.sharedInstance
    }
    
    func bluetoothStatusChanged(notification: NSNotification) {
        let connectionDetails = notification.userInfo
        guard let _ = connectionDetails else {
            return
        }
        
        let connected = connectionDetails!["isConnected"] as! Bool
        statusLabel.text = connected ? "Connected" : "Disconnected"
    }
    
}
