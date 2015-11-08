//
//  IZDiscovery.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import CoreBluetooth

class IZDiscovery: CBCentralManagerDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral? = nil
    var bleService: IZService? = nil
    
    class var sharedInstance: IZDiscovery {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: IZDiscovery? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = IZDiscovery()
        }
        return Static.instance!
    }
    
    override init() {
        super.init()
        let centralQueue = dispatch_queue_create("org.izipperteam", DISPATCH_QUEUE_SERIAL)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func startScanning() {
        self.centralManager.scanForPeripheralsWithServices([RWT_BLE_SERVICE_UUID], options: nil)
    }
    
    func setBleServices(bleService: IZService) {
        self.bleService = bleService
        self.bleService?.startDiscoveringServices()
        
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        // Can't be null, so you don't need to check peripheral == null
        guard let _ = peripheral.name else {
            return
        }
        
        if self.peripheral?.state == .Disconnected {
            //retain the peripheral before trying to connect
            self.peripheral = peripheral
            //reset service
            self.bleService = nil
            //connect to peripheral
            self.centralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            self.bleService = IZService(peripheral: peripheral)
        }
        self.centralManager.stopScan()
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        if peripheral == self.peripheral {
            self.bleService = nil
        }
        self.startScanning()
    }
    
    func clearDevices(){
        self.bleService = nil
        self.peripheral = nil
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        switch self.centralManager.state {
            
        case .PoweredOff:
            self.clearDevices()
            
        case .Unauthorized:
            //indicate to user that the IOS device doe not suppport BLE
            break
            
        case .Unknown:
            //wait for another event
            break
            
        case .PoweredOn:
            self.startScanning()
            
        case .Resetting:
            self.clearDevices()
            
        default:
            break
            
        }
        
        
    }
    
    
    
    
    
}
