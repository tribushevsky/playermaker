//
//  SearchDevicesDependenciesProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

protocol SearchDevicesDependenciesProtocol {

	var bluetooth: BluetoothServiceProtocol { get }
	var storage: ReactiveLocalStorageServiceProtocol { get }

}
