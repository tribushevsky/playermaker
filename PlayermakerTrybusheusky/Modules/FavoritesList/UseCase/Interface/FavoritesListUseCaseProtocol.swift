//
//  FavoritesListUseCaseProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

protocol FavoritesListUseCaseProtocol {

	func updateDevice(device: FavoriteDeviceModel) -> Single<FavoriteDeviceModel>
	func deleteDevice(device: FavoriteDeviceModel) -> Single<Void>
	func devicesList(sortCriterion: FavoriteDeviceSortCriterion) -> Observable<[FavoriteDeviceModel]>

}
