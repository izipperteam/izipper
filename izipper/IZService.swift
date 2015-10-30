//
//  IZService.swift
//  izipper
//
//  Created by Alan Jin on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit
import CoreBluetooth


var kBLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

class IZService: NSObject, CBPeripheralDelegate {
    
    private var peripheral: CBPeripheral
    private var characteristic: CBCharacteristic
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.peripheral.delegate = self
    }
    
    func reset() {
        self.peripheral = nil
    
        
    }
    
    func startDiscoveringServices() {
        
        
    }
    
    func writePosition(position: Uint8) {
        
        
    }
    
    // CBPeripheralDelegate methods
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        var services = peripheral.services
        
        guard let _ = services else {
            return
        }
        
        if services.count == 0 {
            return
        }
        
        for service in services {
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
    }
    
    

}
