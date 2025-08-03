//
//  SearchDevicesDependencies.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

final class SearchDevicesDependencies: SearchDevicesDependenciesProtocol {

	let bluetooth: BluetoothServiceProtocol
	let storage: ReactiveLocalStorageServiceProtocol

	init(
		bluetooth: BluetoothServiceProtocol,
		storage: ReactiveLocalStorageServiceProtocol
	) {
		self.bluetooth = bluetooth
		self.storage = storage
	}

}
