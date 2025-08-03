//
//  SearchDevicesUseCaseProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

protocol SearchDevicesUseCaseProtocol {

	var favoriteDevices: Observable<[FavoriteDeviceModel]> { get }

	func startScanning() -> Observable<[DiscoveredDeviceModel]>
	func deleteFavoriteDevice(device: FavoriteDeviceModel) -> Single<Void>
	func createFavoriteDevice(device: FavoriteDeviceModel) -> Single<FavoriteDeviceModel>

}
