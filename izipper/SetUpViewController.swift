//
//  FirstViewController.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit

class SetupViewController: UITableViewController, Sender, Receiver,timeAndLocationDataSource
{
    @IBOutlet weak var BLEstatus: UILabel!
    @IBOutlet weak var batteryStatus: UILabel!
    @IBOutlet weak var ledStatus: UILabel!
    @IBOutlet weak var buzzerStatus: UILabel!
    @IBOutlet weak var recordingStatus: UILabel!
    
    @IBOutlet weak var LEDswitch: UISwitch!
    @IBOutlet weak var BLEswitch: UISwitch!
    @IBOutlet weak var Buzzerswitch: UISwitch!
    @IBOutlet weak var Recordingswitch: UISwitch!
    
    @IBOutlet weak var readData: UISwitch!
    
    var allowTX = true
    var zipperStatus = [(String, String)]() //the first one is Time, the second one is Location.
    var isReady: Bool {
        return self.BLEstatus.text == "connected"
    }
    
    var refreshHistoryTableController = UIRefreshControl()//while pull down the table, it will automatically refresh the table
    override func viewDidLoad()
    {
        super.viewDidLoad()
        readData.addTarget(self, action: "readData:", forControlEvents: .TouchUpInside)
        BLEswitch.addTarget(self, action: "BLEswitch:", forControlEvents: .TouchUpInside)
        LEDswitch.addTarget(self, action: "LEDswitch:", forControlEvents: .TouchUpInside)
        Buzzerswitch.addTarget(self, action: "Buzzerswitch:", forControlEvents: .TouchUpInside)
        Recordingswitch.addTarget(self, action: "Recordingswitch", forControlEvents: .TouchUpInside)
        
        
        self.refreshControl = self.refreshHistoryTableController
        self.refreshControl?.addTarget(self, action: "didRefreshTable:", forControlEvents: .TouchUpInside)
        // Watch Bluetooth connection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
        
        // Start the Bluetooth discovery process
        //btDiscoverySharedInstance
        
        
        
        
        
    }
    func readData(sender: UISwitch) {
        if sender.on {
            if let bleService = btDiscoverySharedInstance.bleService
            {
                bleService.readValue()
                
            }
        }
    }
    
    func didRefreshTable(sender: UIRefreshControl) {
        self.send(Command(states: .time))
        self.send(Command(states: .location))
        if let bleService = btDiscoverySharedInstance.bleService
        {
            bleService.readValue()
            print(bleService.characteriticsValue)
            
        }
        //MARK:to test what is in the characteristicsValue
        //                self.receive(Message(rawSequence: characteristicsValue as [UInt8]))
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    //MARK: implement timeAndLocationDataSource function transmitTimeAndLocation
    func transmitTimeAndLocation(sender: SetupViewController) -> [(String, String)]? {
        return self.zipperStatus
    }
    
    
    //MARK: switch action
    func BLEswitch(sender: UISwitch)
    {
        if sender.on {
            btDiscoverySharedInstance.startScanning()
        }
        else {
            btDiscoverySharedInstance.clearDevices()
            
        }
    }
    
    func Recordingswitch(sender:UISwitch) {
        let sequenceToSend = Command(property: .recording, toStatus: sender.on)
        self.send(sequenceToSend)
        
    }
    
    func Buzzerswitch(sender:UISwitch) {
        let sequenceToSend = Command(property: .buzzer, toStatus: sender.on)
        self.send(sequenceToSend)
    }
    
    func LEDswitch(sender:UISwitch) {
        let sequenceToSend = Command(property: .light, toStatus: sender.on)
        self.send(sequenceToSend)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: BLEServiceChangedStatusNotification, object: nil)
    }
    
    func connectionChanged(notification: NSNotification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: Bool]
        
        dispatch_async(dispatch_get_main_queue(),
            {
                // Set image based on connection status
                if let isConnected: Bool = userInfo["isConnected"]
                {
                    if isConnected
                    {
                        //self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Connected")
                        self.BLEstatus.text = "connected"
                        print("connected")
                        
                        // Send default parameter
                        self.send(Command(property: .recording, toStatus: self.Recordingswitch.on))
                        self.send(Command(property: .buzzer, toStatus: self.Buzzerswitch.on))
                        self.send(Command(property: .light, toStatus: self.LEDswitch.on))
                    }
                    else
                    {
                        //self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Disconnected")
                        self.BLEstatus.text = "disconnected"
                        print("disconnected")
                    }
                }
        });
    }
    
    //MARK: implement Sender's protocol
    func send(sequenceToSend: Command) {
        guard isReady && allowTX else {
            return
        }
        var times = 1;
        for byte in sequenceToSend.rawSequence {
            if let bleService = btDiscoverySharedInstance.bleService
            {
                bleService.writePosition(byte)
                print("finished \(times)")
                times++
            }
            
        }
    }
    
    
    //MARK: implement Receiver's protocol
    func receive(message: Message) {
        guard isReady else {
            return
        }
        if let item = message.itemToChange[StateAndProperty.battery]{
            batteryStatus.text = "\(item)"
        }
        if let location = message.itemToChange[StateAndProperty.location] {
            if let time = message.itemToChange[StateAndProperty.time] {
                zipperStatus.append(("\(time)", "\(location)"))
            }
        }
        if let buzzer = message.itemToChange[StateAndProperty.buzzer]{
            buzzerStatus.text = "\(buzzer)"
        }
        if let recording = message.itemToChange[StateAndProperty.recording]{
            recordingStatus.text = "\(recording)"
        }
        if let light = message.itemToChange[StateAndProperty.light]{
            ledStatus.text = "\(light)"
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

