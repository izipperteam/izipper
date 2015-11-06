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
var kBLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"


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
      
        self.sendBTServiceNotificationWithIsBluetoothConnected(false)
        
    }
    
    func dealloc(){
        self.reset()
    }//?
    
    
    func startDiscoveringServices() {
        self.peripheral.discoverServices([RWT_BLE_SERVICE_UUID])//?
    }
    
    func writePosition(position: Uint8) {
        
        
    }
    
    // CBPeripheralDelegate methods
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        var services = peripheral.services
        var uuidsForBTService = [RWT_POSITION_CHAR_UUID]  //?
        
        if (peripheral != self.peripheral){
            return
        }//?
        if let _ = error {
            return
        }//?
        
        services = peripheral.services
        
        guard let _ = services else {
            return
        }
        
        if services.count == 0 {
            return
        }
        
        for service in services {
            if(service.UUID == RWT_BLE_SERVICE_UUID){
                peripheral(discoverCharacteristics:uuidsForBTService, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        var characteristic = services.characteristics
        if (peripheral != self.peripheral){
            return
        }
        if let _ = error {
            return
        }
        for characteristic in characteristics{
            if(characteristic.UUID == RWT_POSITION_CHAR_UUID){
                self.positionCharacteristic = characteristic
            }
            self.sendBTServiceNotificationWithIsBluetoothConnected(true)
        }
        
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected:Bool){
        var connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter(postNotificationName:kBLEServiceChangedStatusNotification, object:self, userInfo:connectionDetails)
        
    }
    

}
