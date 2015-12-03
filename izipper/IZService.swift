//
//  IZService.swift
//  izipper
//
//  Created by Alan Jin on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit
import CoreBluetooth

let BLEServiceUUID: CBUUID = CBUUID(string: "713d0000-503e-4c75-ba94-3148f18d941e")
let TransmitCharUUID: CBUUID =  CBUUID(string: "713d0003-503e-4c75-ba94-3148f18d941e")
let ReceiveCharUUID: CBUUID = CBUUID(string: "713D0002-503E-4C75-BA94-3148F18D941E")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

class IZService: NSObject, CBPeripheralDelegate
{
    var peripheral: CBPeripheral?
    var transmitCharacteristic: CBCharacteristic?
    var receiveCharacteristic: CBCharacteristic?
    var characteriticsValue: NSData?
    
    init(initWithPeripheral peripheral: CBPeripheral)
    {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }
    
    deinit
    {
        self.reset()
    }
    
    func startDiscoveringServices()
    {
        self.peripheral?.discoverServices([BLEServiceUUID])
    }
    
    func reset()
    {
        if peripheral != nil
        {
            peripheral = nil
        }
        
        // Deallocating therefore send notification
        self.sendIZServiceNotificationWithIsBluetoothConnected(false)
    }
    
    // Mark: - CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?)
    {
        print(peripheral.services)
        
        let uuidsForIZServiceRX: [CBUUID] = [TransmitCharUUID]
        let uuidsForIZServiceTX: [CBUUID] = [ReceiveCharUUID]
        
        if (peripheral != self.peripheral)
        {
            print("wrong peripheral")
            return
        }
        
        if (error != nil)
        {
            print("error")
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            print("no services")
            return
        }
        
        for service in peripheral.services! {
            if service.UUID == BLEServiceUUID {
                print("discover service success")
                peripheral.discoverCharacteristics(uuidsForIZServiceRX, forService: service)
                peripheral.discoverCharacteristics(uuidsForIZServiceTX, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if (peripheral != self.peripheral) {
            print("wrong peripheral")
            return
        }
        
        if (error != nil) {
            print("error")
            return
        }
        
        print("trying to find characteristic with UUID: \(TransmitCharUUID)and UUID: \(ReceiveCharUUID)")
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.UUID == TransmitCharUUID {
                    print("characteristic for PositionCharUUID success")
                    self.transmitCharacteristic = characteristic
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                    self.sendIZServiceNotificationWithIsBluetoothConnected(true)
                }
                
                if characteristic.UUID == ReceiveCharUUID {
                    print("characteristic for ReceiveCharUUID success")
                    self.receiveCharacteristic = characteristic
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                }
                
                
            }
            
        }
        
        print(service.characteristics)
    }
    
    // Mark: - Private
    
    func writePosition(position: UInt8) {
        // See if characteristic has been discovered before writing to it
        if let transmitCharacteristic = self.transmitCharacteristic {
            // Need a mutable var to pass to writeValue function
            var positionValue = position
            let data = NSData(bytes: &positionValue, length: sizeof(UInt8))
            self.peripheral?.writeValue(data, forCharacteristic: transmitCharacteristic, type: CBCharacteristicWriteType.WithoutResponse)
        }
    }
    
    func sendIZServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
    }
    
    //MARK: implement readvalue and related function
    func readValue() {
        guard self.peripheral != nil else {
            print("fail to find peripheral when trying to read value")
            return
        }
        guard self.receiveCharacteristic != nil else {
            print("fail to find positionCharacteristics when trying to read value")
            return
        }
        
        self.peripheral?.readValueForCharacteristic(self.receiveCharacteristic!)
        
        print(self.characteriticsValue?.bytes)
        
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error == nil {
            self.characteriticsValue = characteristic.value
            print("succeeded in updating value for characteristics")
            var datastring = NSString(data: self.characteriticsValue!, encoding: NSUTF8StringEncoding)
            print(datastring!)
        }
        else {
            print("UpdateValueForCharacteristics failed!")
        }
        
    }
    
}
