//
//  IZService.swift
//  izipper
//
//  Created by Alan Jin on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit
import CoreBluetooth

/* Services & Characteristics UUIDs */
let RWT_BLE_SERVICE_UUID:CBUUID = CBUUID.UUIDWithString("B8E06067-62AD-41BA-9231-206AE80AB550")
let RWT_POSITION_CHAR_UUID:CBUUID =  CBUUID.UUIDWithString("BF45E40A-DE2A-4BC8-BBA0-E5D6065F1B4B")

/* Notifications */
let kBLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"


/* IZService */
class IZService: NSObject, CBPeripheralDelegate {
    
    private var peripheral: CBPeripheral
    private var characteristic: CBCharacteristic
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.peripheral.delegate = self
    }
    
    func reset() {
        self.peripheral = nil
      
        self.sendStatusChangedNotification(false)
    }
    
    func startDiscoveringServices() {
        self.peripheral.discoverServices([RWT_BLE_SERVICE_UUID])//?
    }
    
    func writePosition(position: Uint8) {
        
    }
    
    // CBPeripheralDelegate methods
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        var services = peripheral.services
        var uuidsForBTService = [RWT_POSITION_CHAR_UUID]  //?
        
        guard peripheral == self.peripheral && error == nil else {
            return
        }
        
        services = peripheral.services
        
        guard let _ = services else {
            return
        }
        
        guard !services.isEmpty else {
            return
        }
        
        for service in services {
            if (service.UUID == RWT_BLE_SERVICE_UUID) {
                peripheral(discoverCharacteristics:uuidsForBTService, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        var characteristic = services.characteristics
        if (peripheral != self.peripheral) {
            return
        }
        if let _ = error {
            return
        }
        for characteristic in characteristics {
            if(characteristic.UUID == RWT_POSITION_CHAR_UUID){
                self.positionCharacteristic = characteristic
            }
            self.sendStatusChangedNotification(true)
        }
    }
    
    func sendStatusChangedNotification(isBluetoothConnected:Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter(postNotificationName:kBLEServiceChangedStatusNotification, object:self, userInfo:connectionDetails)
    }
    

}
