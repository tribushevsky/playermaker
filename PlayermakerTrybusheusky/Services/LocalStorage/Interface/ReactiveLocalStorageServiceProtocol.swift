//
//  ReactiveLocalStorageServiceProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import RxSwift

protocol ReactiveLocalStorageServiceProtocol: LocalStorageServiceProtocol {

	func create(sample: FavoriteDeviceModel) -> Single<FavoriteDeviceModel>
	func update(sample: FavoriteDeviceModel) -> Single<FavoriteDeviceModel>
	func delete(sample: FavoriteDeviceModel) -> Single<Void>
	func samples(sort: FavoriteDeviceSortCriterion) -> Observable<[FavoriteDeviceModel]>

}
