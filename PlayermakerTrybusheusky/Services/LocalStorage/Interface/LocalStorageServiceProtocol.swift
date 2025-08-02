//
//  LocalStorageServiceProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

protocol LocalStorageServiceProtocol {

	func create(sample: FavoriteDeviceModel, completion: ((Result<FavoriteDeviceModel, Error>) -> Void)?)
	func update(sample: FavoriteDeviceModel, completion: ((Result<FavoriteDeviceModel, Error>) -> Void)?)
	func delete(sample: FavoriteDeviceModel, completion: ((Result<Void, Error>) -> Void)?)
	func fetchAll(sort: FavoriteDeviceSortCriterion, completion: @escaping ((Result<[FavoriteDeviceModel], Error>) -> Void))

}
