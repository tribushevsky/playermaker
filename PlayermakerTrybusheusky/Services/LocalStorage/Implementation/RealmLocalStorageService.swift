//
//  RealmLocalStorageService.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

final class RealmLocalStorageService {

	private let queue: DispatchQueue
	private let configuration: Realm.Configuration
	private let realm: Realm

	init() throws {
		let cachesDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
		let cachesDirectoryURL = NSURL(fileURLWithPath: cachesDirectoryPath)
		let fileURL = cachesDirectoryURL.appendingPathComponent("playermaker.realm")

		configuration = Realm.Configuration(fileURL: fileURL)
		queue = DispatchQueue(label: "realm_playermaker_local_storage_queue")
		realm = try Realm(configuration: configuration)
	}

}

// MARK: - LocalStorageServiceProtocol

extension RealmLocalStorageService: LocalStorageServiceProtocol {
	
	func create(
		sample: FavoriteDeviceModel,
		completion: ((Result<FavoriteDeviceModel, any Error>) -> Void)?
	) {
		queue.async {
			do {
				let realm = try Realm(configuration: self.configuration)
				let realmDevice = RealmFavoriteDeviceModel(model: sample)

				try realm.write(transaction: {
					realm.add(realmDevice)
				}, completion: {
					completion?(.success(FavoriteDeviceModel(object: realmDevice)))
				})
			} catch let error {
				completion?(.failure(error))
			}
		}
	}

	func update(
		sample: FavoriteDeviceModel,
		completion: ((Result<FavoriteDeviceModel, any Error>) -> Void)?
	) {
		queue.async {
			do {
				let realm = try Realm(configuration: self.configuration)
				guard let realmDevice = realm.object(ofType: RealmFavoriteDeviceModel.self, forPrimaryKey: sample.uuid) else {
					completion?(.failure(LocalStorageCRUDError.objectNotFound))
					return
				}

				try realm.write(transaction: {
					realmDevice.update(by: sample)
					realm.add(realmDevice, update: .modified)
				}, completion: {
					completion?(.success(FavoriteDeviceModel(object: realmDevice)))
				})
			} catch let error {
				completion?(.failure(error))
			}
		}
	}

	func delete(
		sample: FavoriteDeviceModel,
		completion: ((Result<Void, any Error>) -> Void)?
	) {
		queue.async {
			do {
				let realm = try Realm(configuration: self.configuration)
				guard let device = realm.object(ofType: RealmFavoriteDeviceModel.self, forPrimaryKey: sample.uuid) else {
					completion?(.failure(LocalStorageCRUDError.objectNotFound))
					return
				}

				try realm.write(transaction: {
					realm.delete(device)
				}, completion: {
					completion?(.success(()))
				})
			} catch let error {
				completion?(.failure(error))
			}
		}
	}

	func fetchAll(
		sort: FavoriteDeviceSortCriterion,
		completion: @escaping ((Result<[FavoriteDeviceModel], any Error>) -> Void)
	) {
		queue.async {
			do {
				let realm = try Realm(configuration: self.configuration)
				let devices = realm.objects(RealmFavoriteDeviceModel.self).sorted(byKeyPath: sort.rawValue)

				completion(
					.success(Array(devices).map { FavoriteDeviceModel(object: $0) })
				)
			} catch let error {
				completion(.failure(error))
			}
		}
	}

}

// MARK: - ReactiveLocalStorageServiceProtocol

extension RealmLocalStorageService: ReactiveLocalStorageServiceProtocol {

	func create(sample: FavoriteDeviceModel) -> Single<FavoriteDeviceModel> {
		Single.create { single in
			self.create(sample: sample) { result in
				switch result {
				case .success(let device):
					single(.success(device))
				case .failure(let error):
					single(.failure(error))
				}
			}

			return Disposables.create()
		}
	}

	func update(sample: FavoriteDeviceModel) -> Single<FavoriteDeviceModel> {
		Single.create { single in
			self.update(sample: sample) { result in
				switch result {
				case .success(let device):
					single(.success(device))
				case .failure(let error):
					single(.failure(error))
				}
			}

			return Disposables.create()
		}
	}

	func delete(sample: FavoriteDeviceModel) -> Single<Void> {
		Single.create { single in
			self.delete(sample: sample) { result in
				switch result {
				case .success:
					single(.success(()))
				case .failure(let error):
					single(.failure(error))
				}
			}

			return Disposables.create()
		}
	}

	func samples(sort: FavoriteDeviceSortCriterion) -> Observable<[FavoriteDeviceModel]> {
		Observable
			.array(
				from: realm.objects(RealmFavoriteDeviceModel.self).sorted(byKeyPath: sort.rawValue)
			)
			.map { $0.map { FavoriteDeviceModel(object: $0) } }
	}

}
