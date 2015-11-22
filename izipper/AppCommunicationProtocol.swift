//
//  AppCommunicationProtocol.swift
//  izipper
//
//  Created by Frank on 11/22/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import Foundation
/*
Toggle:0xF1
Request:0xF2


Characteristics:
1.Battery    0x04
2.Time       0x05
3.Location   0x06

State:
1.Recording  0x01
2.Buzzer     0x02
3.Light      0x03

Start byte:  0xFF
End byte:    0xEE

*/
enum CentralManagerActions: UInt8{
    case Toggle = 0xF1
    case Request = 0xF2
    
}
enum OnOffSwitch:UInt8{
    case On = 0x01
    case Off = 0x02
}
enum States: UInt8{
    case Recording = 0x01
    case Buzzer = 0x02
    case Light = 0x03
}
enum Characteristics: UInt8{
    case Battery = 0x01
    case Time = 0x02
    case Location = 0x03
}

struct Manager{
    var dataSent:[UInt8]
    var dataReceived: [UInt8]
    init (){
        self.dataSent = [0x00]
        
        //to find out how to receive data, then let dataReceived = [the data received]
        self.dataReceived = [0x00]
    }
    
    //toggle the state of the BLE shield
    mutating func toggle(state:States, switchTo: OnOffSwitch) -> [UInt8] {
        self.dataSent = [UInt8]()
        self.dataSent.append(0xFF)
        self.dataSent.append(CentralManagerActions.Toggle.rawValue)
        self.dataSent.append(state.rawValue)
        self.dataSent.append(switchTo.rawValue)
        self.dataSent.append(0xEE)
        return self.dataSent
    }
    
    //request the characteristic of the BLE shield
    mutating func request(characteristic: Characteristics) -> [UInt8] {
        self.dataSent = [UInt8]()
        self.dataSent.append(0xFF)
        self.dataSent.append(CentralManagerActions.Request.rawValue)
        self.dataSent.append(0xEE)
        return self.dataSent
    }
    
}

