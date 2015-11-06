//
//  IZDiscovery.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import CoreBluetooth
import IZService.swift


class IZDiscovery: NSObject, CBCentralManagerDelegate {
        
        var centralManager: CBCentralManager
        var peripheral: CBPeripheral
        var bleService: IZService? = nil
        
        class var sharedInstance: IZDiscovery {
            struct Static {
                static var onceToken: dispatch_once_t = 0
                static var instance: IZDiscovery? = nil
            }
            dispatch_once(&Static.onceToken) {
                Static.instance = IZDiscovery()
            }
        }
        
        init() {
            let centralQueue = dispatch_queue_create("org.izipperteam", DISPATCH_QUEUE_SERIAL);
            self.centralManager = CBCentralManager(delegate: self, queue: centralQueue);
        }
    func startScanning(){
        self.centralManager.scanForPeripheralsWithServices(<#T##serviceUUIDs: [CBUUID]?##[CBUUID]?#>, options: <#T##[String : AnyObject]?#>)
    }
    
    func setBleServices(bleService: IZService){
        self.bleService = bleService
        self.bleService?.startDiscoveringServices()
        
    }
    
    
        
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        // Can't be null, so you don't need to check peripheral == null
        guard let _ = peripheral.name else {
            return
        }
        
        
        
        
        
        
        
        
        
    }
    
    
   
    
     
}
