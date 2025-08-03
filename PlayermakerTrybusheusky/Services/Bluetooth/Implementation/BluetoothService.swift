//
//  BluetoothService.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 03/08/2025.
//

import Foundation
import CoreBluetooth

final class BluetoothService: NSObject {

	private let syncDataService = BluetoothSyncDataService()
	fileprivate var centralManager: CBCentralManager?
	private var discoveredPeripherals: [UUID: (CBPeripheral, NSNumber)] = [:]
	private var discoveryHandler: ((Result<[DiscoveredDeviceModel], BluetoothServiceError>) -> Void)?

}

// MARK: - Private

extension BluetoothService {

	private func handleBluetoothState(_ state: CBManagerState) {
		switch state {
		case .unauthorized:
			discoveryHandler?(.failure(.unauthorized))
			stopScanning()
		case .poweredOff:
			discoveryHandler?(.failure(.bluetoothOff))
			stopScanning()
		case .unsupported, .resetting, .unknown:
			discoveryHandler?(.failure(.unknownState))
			stopScanning()
		case .poweredOn:
			break
		}
	}

}

// MARK: - BluetoothServiceProtocol

extension BluetoothService: BluetoothServiceProtocol {

	var discoveredDevices: [DiscoveredDeviceModel] {
		discoveredPeripherals.values.map {
			.init(
				uuid: $0.0.identifier.uuidString,
				name: $0.0.name,
				rssi: $0.1.intValue
			)
		}
	}

	func startScanning(discoveryHandler: @escaping (Result<[DiscoveredDeviceModel], BluetoothServiceError>) -> Void) {
		if let existingDiscoveryHandler = self.discoveryHandler {
			existingDiscoveryHandler(.success(discoveredDevices))
		}

		self.discoveryHandler = discoveryHandler
		syncDataService.isScanning = true

		if let centralManager {
			centralManagerDidUpdateState(centralManager)
		} else {
			self.centralManager = CBCentralManager(
				delegate: self,
				queue: nil,
				options: [
					CBCentralManagerOptionShowPowerAlertKey: false
				]
			)
		}
	}

	func stopScanning() {
		guard
			let centralManager
		else {
			return
		}

		discoveryHandler = nil
		discoveredPeripherals.removeAll()
		syncDataService.isScanning = false
		centralManager.stopScan()
	}

}

// MARK: - CBCentralManagerDelegate

extension BluetoothService: CBCentralManagerDelegate {

	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if let centralManager, centralManager.state == .poweredOn, syncDataService.isScanning {
			centralManager.scanForPeripherals(withServices: nil, options: nil)
		} else {
			handleBluetoothState(central.state)
		}
	}

	func centralManager(
		_ central: CBCentralManager,
		didDiscover peripheral: CBPeripheral,
		advertisementData: [String: Any],
		rssi RSSI: NSNumber
	) {
		discoveredPeripherals[peripheral.identifier] = (peripheral, RSSI)
		discoveryHandler?(.success(discoveredDevices))
	}

}

// MARK: - BluetoothSyncDataService

extension BluetoothService {

	private final class BluetoothSyncDataService {

		private lazy var syncQueue: DispatchQueue = .init(
			label: "com.playermaker.bluetooth_service.sync_data",
			attributes: .concurrent
		)

		private var _isScanning: Bool = false

		var isScanning: Bool {
			get {
				syncQueue.sync {
					return _isScanning
				}
			}
			set {
				syncQueue.sync(flags: .barrier) {
					_isScanning = newValue
				}
			}
		}

	}

}


