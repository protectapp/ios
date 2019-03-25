//
//  BluetoothManager.swift
//  Protect_Security
//
//  Created by Jatin Garg on 20/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import CoreBluetooth

@objc protocol BluetoothManagerDelegate: class {
    func didDetermine(bluetoothStateToBe state: CBManagerState )
}

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var btCenteralManager: CBCentralManager!
    public weak var delegate: BluetoothManagerDelegate?
    
    override init() {
        super.init()
        btCenteralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : true])
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.didDetermine(bluetoothStateToBe: central.state)
    }
}
