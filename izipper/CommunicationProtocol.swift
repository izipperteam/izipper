//
//  File.swift
//  izipper
//
//  Created by Frank on 12/2/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

protocol Sender {
    var isReady: Bool { get }
    func send (command: Command)
}
protocol Receiver {
    var isReady: Bool { get }
    func receive(message: Message)
}

//MARK: define protocol DataSequence
protocol DataSequence {
    var rawSequence: [UInt8] { get }
}


//MARK: define struct Command
struct Command: DataSequence {
    var rawSequence: [UInt8]
    init(states: StateAndProperty) {
        self.rawSequence = [0xFF, 0xF1, states.rawValue, 0xEE]
    }
    
    init(property: State, toStatus: Bool) {
        switch toStatus{
        case true:
            self.rawSequence = [0xFF, 0xF2, property.rawValue, 0x01, 0xEE]
        case false:
            self.rawSequence = [0xFF, 0xF2, property.rawValue, 0x00, 0xEE]
        }
        
    }
}


//MARK: define struct Message
struct Message: DataSequence {
    var rawSequence: [UInt8]
    var itemToChange = [StateAndProperty:Status]()
    
    init(rawSequence:[UInt8]) {
        self.rawSequence = rawSequence
        var temp = rawSequence
        temp.removeFirst()
        var index = 0
        while (index + 2) < rawSequence.count {
            index = index + 2
            let item = StateAndProperty(rawValue: temp.removeFirst())
            let status = Status(rawValue: temp.removeFirst())
            self.itemToChange[item!] = status!
        }
    }
    
    
}
enum Status: UInt8 {
    case on = 0x01
    case off = 0x02
    
}
enum StateAndProperty: UInt8 {
    case recording = 0x01
    case buzzer = 0x02
    case light = 0x03
    case battery = 0x04
    case time = 0x05
    case location = 0x06
}

enum State: UInt8 {
    
    case recording = 0x01
    case buzzer = 0x02
    case light = 0x03
}

enum Properties: UInt8 {
    case battery = 0x04
    case time = 0x05
    case location = 0x06
}



