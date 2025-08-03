//
//  BluetoothServiceProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 03/08/2025.
//

enum BluetoothServiceError: Error {

	case bluetoothOff
	case unauthorized
	case unknownState

}

protocol BluetoothServiceProtocol {

	var discoveredDevices: [DiscoveredDeviceModel] { get }

	func startScanning(discoveryHandler: @escaping (Result<[DiscoveredDeviceModel], BluetoothServiceError>) -> Void)
	func stopScanning()

}
